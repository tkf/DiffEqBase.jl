type SDEProblem{uType,tType,isinplace,NP,F,G,C,MM,ND} <: AbstractSDEProblem{uType,tType,isinplace,ND}
  f::F
  g::G
  u0::uType
  tspan::Tuple{tType,tType}
  noise::NP
  callback::C
  mass_matrix::MM
  noise_rate_prototype::ND
  seed::UInt64
end

function SDEProblem(f,g,u0,tspan;iip = isinplace(f,3),
        noise_rate_prototype = nothing,
        noise= nothing, seed = UInt64(0),
        callback = nothing,mass_matrix=I)

  if mass_matrix == I && typeof(f) <: Tuple
    _mm = ((I for i in 1:length(f))...)
  else
    _mm = mass_matrix
  end

  SDEProblem{typeof(u0),promote_type(map(typeof,tspan)...),iip,typeof(noise),
             typeof(f),typeof(g),typeof(callback),typeof(_mm),
             typeof(noise_rate_prototype)}(
  f,g,u0,tspan,noise,callback,_mm,noise_rate_prototype,seed)
end
