namespace :db do
  desc "Fill database with smells like fail crew"
  task populate: :environment do
    User.create!(nickname: "kroy",
                 hon_id: "211652")
    User.create!(nickname: "Strategyst",
                 hon_id: "866895")
     User.create!(nickname: "Ocan",
                 hon_id: "1716156")
     User.create!(nickname: "Atomic1",
                 hon_id: "4379919")
     User.create!(nickname: "Zimrak",
                 hon_id: "4382939")
     User.create!(nickname: "Slithe7",
                 hon_id: "6227189")
     User.create!(nickname: "USS1994",
                 hon_id: "6227181")
     User.create!(nickname: "Strategysts",
                 hon_id: "7365617")
     User.create!(nickname: "SubStrategy",
                 hon_id: "6812540")
  end
end