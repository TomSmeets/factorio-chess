-- data.lua - define the new chess items and entities
-- Copyright Tom Smeets 2023 <tom@tsmeets.nl>

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
            icon = image,
            icon_size = 128,
            icon_mipmaps = 1,
            order = order .. "[" .. name .. "]",
            place_result = name,
            stack_size = 50
        },

        -- the crafting recipe for the above item
        -- currently they are very cheap
        {
            type = "recipe",
            name = name,
            enabled = true,
            ingredients = {
                { "stone", 4 },
            },
            result = name
        },

        -- the actually entity on the ground
        -- a simple-entity-with-owner type implements the EntityWithOwner prototype
        -- and has all properties of 'normal' placable entities in factorio
        {
            type = "simple-entity-with-owner",
            name = name,
            fast_replaceable_group = "chess-piece",
            collision_box = { { -0.6, -0.6 }, {  0.6,  0.6 } },
            selection_box = { { -0.8, -0.8 }, {  0.8,  0.8 } },
            flags = { "placeable-neutral", "player-creation" },
            icon = image,
            icon_mipmaps = 4,
            icon_size = 128,
            pictures = {
                filename = image,
                priority = "extra-high",
                width = 128,
                height = 128,
                scale = 0.5,
            },
            max_health = 50,
            minable = {
                mining_time = 0.1,
                result = name
            },
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
            collision_mask = {"ground-tile"},
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
            map_color={ r=1, g=1, b=1 },
            pollution_absorption_per_second = 0,
        },
        {
            type = "item",
            name = name,
            icon = image,
            icon_size = 32,
            icon_mipmaps = 1,
            order = "a[" .. name .. "]",
            stack_size = 50,
            place_as_tile = {
                result = name,
                result_count = 4,
                condition_size = 1,
                condition = { "water-tile" }
            }
        },
        {
            type = "recipe",
            name = name,
            enabled = true,
            ingredients = {
                { "stone", 1 },
            },
            result = name
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
