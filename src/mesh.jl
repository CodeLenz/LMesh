
abstract type Mesh end

mutable struct Mesh2D <: Mesh

   # Background mesh 
   bmesh::Bmesh2D

   # Materials
   nmat::Int64
   materials::Vector{Material}

   # Geometries
   ngeom::Int64
   geometries::Vector{Geometry}

   # Supports (essential boundary conditions)
   # node gl value
   nebc::Int64
   ebc::Matrix{Float64}

   # Point Loads (natural boundary conditions)
   # node gl value
   nnbc::Int64
   nbc::Matrix{Float64}

   # Free dofs
   ngls::Int64
   free_dofs::Vector{Int64}

   # Map element to material
   mat_ele::Vector{Int64}
  
   # Map element to geometry
   geo_ele::Vector{Int64}
  
   # Dictionary
   options::Dict{Symbol,Matrix{Float64}}

   # Default constructor
   function Mesh2D(bmesh::Bmesh2D,materials::Vector{Material},
                   geometries::Vector{Geometry},ebc::Matrix{Float64},
                   nbc::Matrix{Float64}, mat_ele::Int64[], geo_ele::Int64[] ;
                   options=Dict{Symbol,Matrix{Float64}}())
    
            # Dimensions
            nmat = length(materials)
            ngeo = length(geometries)
            nebc = size(ebc,1)
            nnbc = size(nbc,1)
    
            # Basic tests
            nmat>=1 || throw("Mesh2D::number of material properties must be >=1")
            ngeo>=1 || throw("Mesh2D::number of geometries properties must be >=1")
            nebc>=3 || throw("Mesh2D:: at least three essential boundary conditions are needed in 2D ")

            
            # Process mat_ele 
            if isempy(mat_ele)
               resize!(mat_ele,bmesh.ne)
               fill!(mat_ele,1)
            else
               minimum(mat_ele)>0 || throw("Mesh2D::mat_ele should point to a valid material")
               maximum(mat_ele)<nmat || throw("Mesh2D::mat_ele should point to a valid material")
            end
      
            # Process geo_ele 
            if isempy(geo_ele)
               resize!(geo_ele,bmesh.ne)
               fill!(geo_ele,1)
            else
               minimum(geo_ele)>0 || throw("Mesh2D::geo_ele should point to a valid geometry")
               maximum(geo_ele)<ngeo || throw("Mesh2D::geo_ele should point to a valid geometry")
            end
      
      
            # Free dofs and effective number of gls
            free_dofs, ngls = Free_DOFs(bmesh,nebc,ebc)

            # Create the type
            new(bmesh,nmat,materials,ngeo,geometries,nebc,ebc,nnbc,nbc,ngls,free_dofs,mat_ele,mat_geo,options)
   end
end



mutable struct Mesh3D <: Mesh

   # Background mesh 
   bmesh::Bmesh3D

   # Materials
   nmat::Int64
   materials::Vector{Material}

   # Geometries
   ngeom::Int64
   geometries::Vector{Geometry}

   # Supports (essential boundary conditions)
   # node gl value
   nebc::Int64
   ebc::Matrix{Float64}

   # Point Loads (natural boundary conditions)
   # node gl value
   nnbc::Int64
   nbc::Matrix{Float64}

   # Free dofs
   ngls::Int64
   free_dofs::Vector{Int64}

   # Dictionary
   options::Dict{Symbol,Matrix{Float64}}

   # Default constructor
   function Mesh3D(bmesh::Bmesh3D,materials::Vector{Material},
                   geometries::Vector{Geometry},ebc::Matrix{Float64},
                   nbc::Matrix{Float64}, mat_ele::Int64[], geo_ele::Int64[] ;
                   options=Dict{Symbol,Matrix{Float64}}())

      # Dimensions
      nmat = length(materials)
      ngeo = length(geometries)
      nebc = size(ebc,1)
      nnbc = size(nbc,1)

      # Basic tests
      nmat>=1 || throw("Mesh3D::number of material properties must be >=1")
      ngeo>=1 || throw("Mesh3D::number of geometries properties must be >=1")
      nebc>=5 || throw("Mesh3D:: at least five essential boundary conditions are needed in 3D ")

      
      # Process mat_ele and geo_ele
      if isempy(mat_ele)
         resize!(mat_ele,bmesh.ne)
         fill!(mat_ele,1)
      else
          minimum(mat_ele)>0 || throw("Mesh3D::mat_ele should point to a valid material")
          maximum(mat_ele)<nmat || throw("Mesh3D::mat_ele should point to a valid material")
      end
      
      # Process geo_ele 
      if isempy(geo_ele)
          resize!(geo_ele,bmesh.ne)
          fill!(geo_ele,1)
      else
           minimum(geo_ele)>0 || throw("Mesh2D::geo_ele should point to a valid geometry")
           maximum(geo_ele)<ngeo || throw("Mesh2D::geo_ele should point to a valid geometry")
       end

      
      # Free dofs and effective number of gls
      free_dofs, ngls = Free_DOFs(bmesh,nebc,ebc)

      # Create the type
      new(bmesh,nmat,materials,ngeo,geometries,nebc,ebc,nnbc,nbc,ngls,free_dofs,options)
   end

end

