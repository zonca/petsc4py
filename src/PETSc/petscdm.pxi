# --------------------------------------------------------------------

cdef extern from * nogil:

    ctypedef char* PetscDMType "const char*"
    PetscDMType DMDA_type "DMDA"
    PetscDMType DMCOMPOSITE
    PetscDMType DMSLICED
    PetscDMType DMSHELL
    PetscDMType DMMESH
    PetscDMType DMPLEX
    PetscDMType DMCARTESIAN
    PetscDMType DMREDUNDANT
    PetscDMType DMPATCH
    PetscDMType DMMOAB
    PetscDMType DMNETWORK

    ctypedef enum PetscDMBoundaryType"DMBoundaryType":
        DM_BOUNDARY_NONE
        DM_BOUNDARY_GHOSTED
        DM_BOUNDARY_MIRROR
        DM_BOUNDARY_PERIODIC
        DM_BOUNDARY_TWIST

    int DMCreate(MPI_Comm,PetscDM*)
    int DMClone(PetscDM,PetscDM*)
    int DMDestroy(PetscDM*)
    int DMView(PetscDM,PetscViewer)
    int DMSetType(PetscDM,PetscDMType)
    int DMGetType(PetscDM,PetscDMType*)
    int DMGetDimension(PetscDM,PetscInt*)
    int DMSetDimension(PetscDM,PetscInt)
    int DMSetOptionsPrefix(PetscDM,char[])
    int DMSetFromOptions(PetscDM)
    int DMSetUp(PetscDM)

    int DMGetBlockSize(PetscDM,PetscInt*)
    int DMSetVecType(PetscDM,PetscVecType)
    int DMCreateLocalVector(PetscDM,PetscVec*)
    int DMCreateGlobalVector(PetscDM,PetscVec*)
    int DMSetMatType(PetscDM,PetscMatType)
    int DMCreateMatrix(PetscDM,PetscMat*)

    int DMGetCoordinateDM(PetscDM,PetscDM*)
    int DMGetCoordinateSection(PetscDM,PetscSection*)
    int DMSetCoordinates(PetscDM,PetscVec)
    int DMGetCoordinates(PetscDM,PetscVec*)
    int DMSetCoordinatesLocal(PetscDM,PetscVec)
    int DMGetCoordinatesLocal(PetscDM,PetscVec*)

    int DMCreateInterpolation(PetscDM,PetscDM,PetscMat*,PetscVec*)
    int DMCreateInjection(PetscDM,PetscDM,PetscMat*)
    int DMCreateAggregates(PetscDM,PetscDM,PetscMat*)

    int DMConvert(PetscDM,PetscDMType,PetscDM*)
    int DMRefine(PetscDM,MPI_Comm,PetscDM*)
    int DMCoarsen(PetscDM,MPI_Comm,PetscDM*)
    int DMRefineHierarchy(PetscDM,PetscInt,PetscDM[])
    int DMCoarsenHierarchy(PetscDM,PetscInt,PetscDM[])

    int DMGlobalToLocalBegin(PetscDM,PetscVec,PetscInsertMode,PetscVec)
    int DMGlobalToLocalEnd(PetscDM,PetscVec,PetscInsertMode,PetscVec)
    int DMLocalToGlobalBegin(PetscDM,PetscVec,PetscInsertMode,PetscVec)
    int DMLocalToGlobalEnd(PetscDM,PetscVec,PetscInsertMode,PetscVec)
    int DMLocalToLocalBegin(PetscDM,PetscVec,PetscInsertMode,PetscVec)
    int DMLocalToLocalEnd(PetscDM,PetscVec,PetscInsertMode,PetscVec)

    int DMGetLocalToGlobalMapping(PetscDM,PetscLGMap*)

    int DMSetDefaultSection(PetscDM,PetscSection)
    int DMGetDefaultSection(PetscDM,PetscSection*)
    int DMSetDefaultGlobalSection(PetscDM,PetscSection)
    int DMGetDefaultGlobalSection(PetscDM,PetscSection*)
    int DMCreateDefaultSF(PetscDM,PetscSection,PetscSection)
    int DMGetDefaultSF(PetscDM,PetscSF*)
    int DMSetDefaultSF(PetscDM,PetscSF)
    int DMGetPointSF(PetscDM,PetscSF*)
    int DMSetPointSF(PetscDM,PetscSF)

    int DMShellSetGlobalVector(PetscDM,PetscVec)
    int DMShellSetLocalVector(PetscDM,PetscVec)

# --------------------------------------------------------------------

cdef inline PetscDMBoundaryType asBoundaryType(object boundary) \
    except <PetscDMBoundaryType>(-1):
    if boundary is None:
        return DM_BOUNDARY_NONE
    if isinstance(boundary, str):
        if boundary == 'none':
            return DM_BOUNDARY_NONE
        elif boundary == 'ghosted':
            return DM_BOUNDARY_GHOSTED
        elif boundary == 'mirror':
            return DM_BOUNDARY_MIRROR
        elif boundary == 'periodic':
            return DM_BOUNDARY_PERIODIC
        elif boundary == 'twist':
            return DM_BOUNDARY_TWIST
        else:
            raise ValueError("unknown boundary type: %s" % boundary)
    return boundary

cdef inline PetscInt asBoundary(object boundary,
                                PetscDMBoundaryType *_x,
                                PetscDMBoundaryType *_y,
                                PetscDMBoundaryType *_z) except? -1:
    cdef PetscInt dim = PETSC_DECIDE
    cdef object x, y, z
    if (boundary is None or
        isinstance(boundary, str) or
        isinstance(boundary, int)):
        _x[0] = _y[0] = _z[0] = asBoundaryType(boundary)
    else:
        boundary = tuple(boundary)
        dim = <PetscInt>len(boundary)
        if   dim == 0: pass
        elif dim == 1: (x,) = boundary
        elif dim == 2: (x, y) = boundary
        elif dim == 3: (x, y, z) = boundary
        if dim >= 1: _x[0] = asBoundaryType(x)
        if dim >= 2: _y[0] = asBoundaryType(y)
        if dim >= 3: _z[0] = asBoundaryType(z)
    return dim

cdef inline object toBoundary(PetscInt dim,
                              PetscDMBoundaryType x,
                              PetscDMBoundaryType y,
                              PetscDMBoundaryType z):
    if   dim == 0: return ()
    elif dim == 1: return (x,)
    elif dim == 2: return (x, y)
    elif dim == 3: return (x, y, z)

# --------------------------------------------------------------------
