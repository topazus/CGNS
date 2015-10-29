      program write_grid2zn_str
      use cgns
c
c   Creates simple 3-D structured grid WITH 2 ZONES and writes 
c   it to a CGNS file.
c
c   This program uses the fortran convention that all
c   variables beginning with the letters i-n are integers,
c   by default, and all others are real
c
c   Example compilation for this program is (change paths!):
c   Note: when using the cgns module file, you must use the SAME fortran compiler 
c   used to compile CGNS (see make.defs file)
c   ...or change, for example, via environment "setenv FC ifort"
c
c   ifort -I ../../../CGNS_github/CGNS/src -c write_grid2zn_str.f
c   ifort -o write_grid2zn_str write_grid2zn_str.o -L ../../../CGNS_github/CGNS/src/lib -lcgns
c
c   (../../../CGNS_github/CGNS/src/lib is the location where the compiled
c   library libcgns.a is located)
c
c   The following is no longer supported; now superceded by "use cgns":
c     include 'cgnslib_f.h'
c   Note Windows machines need to include cgnswin_f.h
c
c   dimension statements (note that tri-dimensional arrays
c   x,y,z must be dimensioned exactly as (21,17,N) (N>=9) 
c   for this particular case or else they will be written to 
c   the CGNS file incorrectly!  Other options are to use 1-D 
c   arrays, use dynamic memory, or pass index values to a 
c   subroutine and dimension exactly there):
      real*8 x1(21,17,9),y1(21,17,9),z1(21,17,9)
      real*8 x2(21,17,9),y2(21,17,9),z2(21,17,9)
      integer(cgsize_t) isize(3,3)
      character basename*32,zonename*32
c
      write(6,'('' Program write_grid2zn_str'')')
      if (CG_BUILD_64BIT) then
        write(6,'('' ...using 64-bit mode for particular integers'')')
      end if
c
c   create gridpoints for simple example:
      ni=21
      nj=17
      nk=9
      do k=1,nk
        do j=1,nj
          do i=1,ni
            x1(i,j,k)=float(i-1)
            y1(i,j,k)=float(j-1)
            z1(i,j,k)=float(k-1)
            x2(i,j,k)=x1(i,j,k)+20.d0
            y2(i,j,k)=y1(i,j,k)
            z2(i,j,k)=z1(i,j,k)
          enddo
        enddo
      enddo
      write(6,'('' created simple 3-D grid points (2 zones)'')')
c
c   WRITE X, Y, Z GRID POINTS TO CGNS FILE
c   open CGNS file for write
      call cg_open_f('grid.cgns',CG_MODE_WRITE,index_file,ier)
      if (ier .ne. CG_OK) call cg_error_exit_f
c   create base (user can give any name)
      basename='Base'
      icelldim=3
      iphysdim=3
      call cg_base_write_f(index_file,basename,icelldim,iphysdim,
     + index_base,ier)
c   vertex size
      isize(1,1)=21
      isize(2,1)=17
      isize(3,1)=9
c   cell size
      isize(1,2)=isize(1,1)-1
      isize(2,2)=isize(2,1)-1
      isize(3,2)=isize(3,1)-1
c   boundary vertex size (always zero for structured grids)
      isize(1,3)=0
      isize(2,3)=0
      isize(3,3)=0
c   define zone 1 name (user can give any name)
      zonename = 'Zone  1'
c   create zone
      call cg_zone_write_f(index_file,index_base,zonename,isize,
     + Structured,index_zone,ier)
c   write grid coordinates (user must use SIDS-standard names here)
      call cg_coord_write_f(index_file,index_base,index_zone,RealDouble,
     + 'CoordinateX',x1,index_coord,ier)
      call cg_coord_write_f(index_file,index_base,index_zone,RealDouble,
     + 'CoordinateY',y1,index_coord,ier)
      call cg_coord_write_f(index_file,index_base,index_zone,RealDouble,
     + 'CoordinateZ',z1,index_coord,ier)
c   define zone 2 name (user can give any name)
      zonename = 'Zone  2'
c   create zone
      call cg_zone_write_f(index_file,index_base,zonename,isize,
     + Structured,index_zone,ier)
c   write grid coordinates (user must use SIDS-standard names here)
      call cg_coord_write_f(index_file,index_base,index_zone,RealDouble,
     + 'CoordinateX',x2,index_coord,ier)
      call cg_coord_write_f(index_file,index_base,index_zone,RealDouble,
     + 'CoordinateY',y2,index_coord,ier)
      call cg_coord_write_f(index_file,index_base,index_zone,RealDouble,
     + 'CoordinateZ',z2,index_coord,ier)
c   close CGNS file
      call cg_close_f(index_file,ier)
      write(6,'('' Successfully wrote grid to file grid.cgns'')')
      stop
      end
