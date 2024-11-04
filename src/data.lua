-- data.lua - define the new chess items and entities
-- Copyright Tom Smeets 2023 <tom@tsmeets.nl>
local tile_collision_masks = require("__base__/prototypes/tile/tile-collision-masks")

-- register a new chess piece
--   kind: which piece it is 'wP' is 'white pawn', 'bN' is 'black knight'
function make_piece(kind, order)
    -- which art pack to use, currently we only have cburnett
    local pack = "cburnett"
    local image = "__chess__/assets/"..pack.."/" .. kind .. ".png"
    local name = "chess-piece-" .. pack .. "-" .. kind
    data:extend({
        -- The item version, that is present in your inventory
        -- becomes the entity once placed
        {
            type = "item",
            name = name,
            order = order .. "[" .. name .. "]",

            stack_size = 50,
            icon = image,
            icon_size = 128,
            place_result = name
        },

        -- the crafting recipe for the above item
        -- currently they are very cheap
        {
            type = "recipe",
            name = name,
            ingredients = {
                { type = "item", name = "stone", amount = 4 }
            },
            results = {
                { type = "item", name = name, amount = 1 }
            }
        },

        -- the actually entity on the ground
        -- a simple-entity-with-owner type implements the EntityWithOwner prototype
        -- and has all properties of 'normal' placable entities in factorio
        {
            type = "simple-entity-with-owner",
            name = name,

            -- Entity
            icon = image,
            icon_size = 128,
            collision_box = { { -0.6, -0.6 }, {  0.6,  0.6 } },
            selection_box = { { -0.8, -0.8 }, {  0.8,  0.8 } },
            flags = { "placeable-neutral", "player-creation" },
            minable = {
                mining_time = 0.1,
                results = {
                    { type = "item", name = name, amount = 1 }
                }
            },
            fast_replaceable_group = "chess-piece",

            -- Entyty With Health
            max_health = 50,

            -- Simple Entity With Owner
            pictures = {
                {
                    filename = image,
                    size = 128,
                    scale = 0.5
                }
            }
        }
    })
end

-- Register a new placeable background tile for a given color
-- color is either 'white' or 'black'
function make_tile(color)
    local name = "chess-tile-" .. color
    local image = "__chess__/assets/" .. color .. ".png"
    data:extend({
        {
            type = "tile",
            name = name,
            order = "z[other]-b[lab]-c[lab-white]",

            -- Tile Prototype
            collision_mask = tile_collision_masks.ground,
            layer = 61,
            minable     = { mining_time = 0.025, result = name },
            mined_sound = { filename = "__base__/sound/deconstruct-bricks.ogg",volume = 0.8},
            decorative_removal_probability = 1.0,
            variants = {
                main = {
                    {
                        picture = image,
                        count = 1,
                        size = 1
                    },
                },
                empty_transitions = true
            },
            map_color={ r=1, g=1, b=1 }
        },
        {
            type = "item",
            name = name,
            order = "a[" .. name .. "]",

            stack_size = 50,
            icon = image,
            icon_size = 32,
            place_as_tile = {
                result = name,
                result_count = 4,
                condition_size = 1,
                condition = { layers={water_tile=true} }
            }
        },
        {
            type = "recipe",
            name = name,
            enabled = true,
            ingredients = {
                { type = "item", name = "stone", amount = 1 },
            },
            results = {
                { type = "item", name = name, amount = 1 }
            }
        },
    })
end

-- register the actual pieces
make_piece("wP", "aa");
make_piece("wN", "ab");
make_piece("wB", "ac");
make_piece("wR", "ad");
make_piece("wK", "ae");
make_piece("wQ", "af");

make_piece("bP", "ba");
make_piece("bN", "bb");
make_piece("bB", "bc");
make_piece("bR", "bd");
make_piece("bK", "be");
make_piece("bQ", "bf");

make_tile("white");
make_tile("black");
