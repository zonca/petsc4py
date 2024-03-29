cdef class DMShell(DM):

    def create(self, comm=None):
        cdef MPI_Comm ccomm = def_Comm(comm, PETSC_COMM_DEFAULT)
        cdef PetscDM newdm = NULL
        CHKERR( DMShellCreate(ccomm, &newdm) )
        PetscCLEAR(self.obj); self.dm = newdm
        return self

    def setMatrix(self, Mat mat not None):
        CHKERR( DMShellSetMatrix(self.dm, mat.mat) )

    def setGlobalVector(self, Vec gv not None):
        CHKERR( DMShellSetGlobalVector(self.dm, gv.vec) )

    def setLocalVector(self, Vec lv not None):
        CHKERR( DMShellSetLocalVector(self.dm, lv.vec) )

    def setCreateGlobalVector(self, create_gvec, args=None, kargs=None):
        if create_gvec is not None:
            if args  is None: args = ()
            if kargs is None: kargs = {}
            context = (create_gvec, args, kargs)
            self.set_attr('__create_global_vector__', context)
            CHKERR( DMShellSetCreateGlobalVector(self.dm, DMSHELL_CreateGlobalVector) )
        else:
            CHKERR( DMShellSetCreateGlobalVector(self.dm, NULL) )

    def setCreateLocalVector(self, create_lvec, args=None, kargs=None):
        if create_lvec is not None:
            if args  is None: args = ()
            if kargs is None: kargs = {}
            context = (create_lvec, args, kargs)
            self.set_attr('__create_local_vector__', context)
            CHKERR( DMShellSetCreateLocalVector(self.dm, DMSHELL_CreateLocalVector) )
        else:
            CHKERR( DMShellSetCreateLocalVector(self.dm, NULL) )

    def setGlobalToLocal(self, begin, end, begin_args=None, begin_kargs=None,
                         end_args=None, end_kargs=None):
        cdef PetscDMShellXToYFunction cbegin = NULL, cend = NULL
        if begin is not None:
            if begin_args  is None: args = ()
            if begin_kargs is None: kargs = {}
            context = (begin, args, kargs)
            self.set_attr('__g2l_begin__', context)
            cbegin = &DMSHELL_GlobalToLocalBegin
        if end is not None:
            if end_args  is None: args = ()
            if end_kargs is None: kargs = {}
            context = (end, args, kargs)
            self.set_attr('__g2l_end__', context)
            cend = &DMSHELL_GlobalToLocalEnd
        CHKERR( DMShellSetGlobalToLocal(self.dm, cbegin, cend) )

    def setGlobalToLocalVecScatter(self, Scatter gtol not None):
        CHKERR( DMShellSetGlobalToLocalVecScatter(self.dm, gtol.sct) )

    def setLocalToGlobal(self, begin, end, begin_args=None, begin_kargs=None,
                         end_args=None, end_kargs=None):
        cdef PetscDMShellXToYFunction cbegin = NULL, cend = NULL
        if begin is not None:
            if begin_args  is None: args = ()
            if begin_kargs is None: kargs = {}
            context = (begin, args, kargs)
            self.set_attr('__l2g_begin__', context)
            cbegin = &DMSHELL_LocalToGlobalBegin
        if end is not None:
            if end_args  is None: args = ()
            if end_kargs is None: kargs = {}
            context = (end, args, kargs)
            self.set_attr('__l2g_end__', context)
            cend = &DMSHELL_LocalToGlobalEnd
        CHKERR( DMShellSetLocalToGlobal(self.dm, cbegin, cend) )

    def setLocalToGlobalVecScatter(self, Scatter ltog not None):
        CHKERR( DMShellSetLocalToGlobalVecScatter(self.dm, ltog.sct) )

    def setLocalToLocal(self, begin, end, begin_args=None, begin_kargs=None,
                        end_args=None, end_kargs=None):
        cdef PetscDMShellXToYFunction cbegin = NULL, cend = NULL
        cbegin = NULL
        cend = NULL
        if begin is not None:
            if begin_args  is None: args = ()
            if begin_kargs is None: kargs = {}
            context = (begin, args, kargs)
            self.set_attr('__l2l_begin__', context)
            cbegin = &DMSHELL_LocalToLocalBegin
        if end is not None:
            if end_args  is None: args = ()
            if end_kargs is None: kargs = {}
            context = (end, args, kargs)
            self.set_attr('__l2l_end__', context)
            cend = &DMSHELL_LocalToLocalEnd
        CHKERR( DMShellSetLocalToLocal(self.dm, cbegin, cend) )

    def setLocalToLocalVecScatter(self, Scatter ltol not None):
        CHKERR( DMShellSetLocalToLocalVecScatter(self.dm, ltol.sct) )

    def setCreateMatrix(self, create_matrix, args=None, kargs=None):
        if create_matrix is not None:
            if args  is None: args  = ()
            if kargs is None: kargs = {}
            context = (create_matrix, args, kargs)
            self.set_attr('__create_matrix__', context)
            CHKERR( DMShellSetCreateMatrix(self.dm, DMSHELL_CreateMatrix) )
        else:
            CHKERR( DMShellSetCreateMatrix(self.dm, NULL) )

    def setCoarsen(self, coarsen, args=None, kargs=None):
        if coarsen is not None:
            if args  is None: args  = ()
            if kargs is None: kargs = {}
            context = (coarsen, args, kargs)
            self.set_attr('__coarsen__', context)
            CHKERR( DMShellSetCoarsen(self.dm, DMSHELL_Coarsen) )
        else:
            CHKERR( DMShellSetCoarsen(self.dm, NULL) )

    def setRefine(self, refine, args=None, kargs=None):
        if refine is not None:
            if args  is None: args  = ()
            if kargs is None: kargs = {}
            context = (refine, args, kargs)
            self.set_attr('__refine__', context)
            CHKERR( DMShellSetRefine(self.dm, DMSHELL_Refine) )
        else:
            CHKERR( DMShellSetRefine(self.dm, NULL) )

    def setCreateInterpolation(self, create_interpolation, args=None, kargs=None):
        if create_interpolation is not None:
            if args  is None: args  = ()
            if kargs is None: kargs = {}
            context = (create_interpolation, args, kargs)
            self.set_attr('__create_interpolation__', context)
            CHKERR( DMShellSetCreateInterpolation(self.dm, DMSHELL_CreateInterpolation) )
        else:
            CHKERR( DMShellSetCreateInterpolation(self.dm, NULL) )

    def setCreateInjection(self, create_injection, args=None, kargs=None):
        if create_injection is not None:
            if args  is None: args  = ()
            if kargs is None: kargs = {}
            context = (create_injection, args, kargs)
            self.set_attr('__create_injection__', context)
            CHKERR( DMShellSetCreateInjection(self.dm, DMSHELL_CreateInjection) )
        else:
            CHKERR( DMShellSetCreateInjection(self.dm, NULL) )

    def setCreateFieldDecomposition(self, decomp, args=None, kargs=None):
        if decomp is not None:
            if args  is None: args = ()
            if kargs is None: kargs = {}
            context = (decomp, args, kargs)
            self.set_attr('__create_field_decomp__', context)
            CHKERR( DMShellSetCreateFieldDecomposition(self.dm, DMSHELL_CreateFieldDecomposition) )
        else:
            CHKERR( DMShellSetCreateFieldDecomposition(self.dm, NULL) )

    def setCreateSubDM(self, create_subdm, args=None, kargs=None):
        if create_subdm is not None:
            if args  is None: args = ()
            if kargs is None: kargs = {}
            context = (create_subdm, args, kargs)
            self.set_attr('__create_subdm__', context)
            CHKERR( DMShellSetCreateSubDM(self.dm, DMSHELL_CreateSubDM) )
        else:
            CHKERR( DMShellSetCreateSubDM(self.dm, NULL) )
