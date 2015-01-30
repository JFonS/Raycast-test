-- helpers for lua coding

-- simplifies OOP
--[[
function class(name, superclass)
    local cls = superclass and superclass() or {}
    cls.__name = name or ""
    cls.__super = superclass
    return setmetatable(cls, {__call = function (c, ...)
        local self = setmetatable({__class = cls}, cls)
        if cls.__init then
            cls.__init(self, ...)
        end
        for k,v in pairs(cls) do
            self[k] = v
        end
        return self
    end})
end
]]--

function class(name, super)
    -- main metadata
    local cls = {}
    cls.__name = name
    cls.__super = super

    -- copy the members of the superclass
    if super then
        for k,v in pairs(super) do
            cls[k] = v
        end
    end

    -- when the class object is being called,
    -- create a new object containing the class'
    -- members, calling its __init with the given
    -- params
    cls = setmetatable(cls, {__call = function(c, ...)
        local obj = {}
        for k,v in pairs(cls) do
            --if not k == "__call" then
                obj[k] = v
            --end
        end
        if obj.__init then obj:__init(...) end
        return obj
    end})
    return cls
end


-- Converts HSL to RGB (input and output range: 0 - 255)
function hsl2rgb(h, s, l)
   if s == 0 then return l,l,l end
   h, s, l = h/256*6, s/255, l/255
   local c = (1-math.abs(2*l-1))*s
   local x = (1-math.abs(h%2-1))*c
   local m,r,g,b = (l-.5*c), 0,0,0
   if h < 1     then r,g,b = c,x,0
   elseif h < 2 then r,g,b = x,c,0
   elseif h < 3 then r,g,b = 0,c,x
   elseif h < 4 then r,g,b = 0,x,c
   elseif h < 5 then r,g,b = x,0,c
   else              r,g,b = c,0,x
   end
   return math.ceil((r+m)*256),math.ceil((g+m)*256),math.ceil((b+m)*256)
end

function getIntersection(ray, segment)

  -- RAY in parametric: Point + Direction*T1
  local r_px = ray.a.x
  local r_py = ray.a.y
  local r_dx = ray.b.x-ray.a.x
  local r_dy = ray.b.y-ray.a.y



  -- SEGMENT in parametric: Point + Direction*T2
  local s_px = segment.a.x
  local s_py = segment.a.y
  local s_dx = segment.b.x-segment.a.x
  local s_dy = segment.b.y-segment.a.y

  -- Are they parallel? If so, no intersect
  local r_mag = math.sqrt(r_dx*r_dx+r_dy*r_dy)
  local s_mag = math.sqrt(s_dx*s_dx+s_dy*s_dy)

  if r_dx/r_mag==s_dx/s_mag and r_dy/r_mag==s_dy/s_mag then -- Directions are the same.
    return nil
  end

  -- SOLVE FOR T1 & T2
  -- r_px+r_dx*T1 = s_px+s_dx*T2 && r_py+r_dy*T1 = s_py+s_dy*T2
  -- ==> T1 = (s_px+s_dx*T2-r_px)/r_dx = (s_py+s_dy*T2-r_py)/r_dy
  -- ==> s_px*r_dy + s_dx*T2*r_dy - r_px*r_dy = s_py*r_dx + s_dy*T2*r_dx - r_py*r_dx
  -- ==> T2 = (r_dx*(s_py-r_py) + r_dy*(r_px-s_px))/(s_dx*r_dy - s_dy*r_dx)
  local T2 = (r_dx*(s_py-r_py) + r_dy*(r_px-s_px))/(s_dx*r_dy - s_dy*r_dx)
  local T1 = (s_px+s_dx*T2-r_px)/r_dx

  -- Must be within parametic whatevers for RAY/SEGMENT
  if T1<0 then return nil end
  if T2<0 or T2>1  then return nil end

  -- Return the POINT OF INTERSECTION
  return {
    x = r_px+r_dx*T1,
    y = r_py+r_dy*T1,
    param = T1
  }

end