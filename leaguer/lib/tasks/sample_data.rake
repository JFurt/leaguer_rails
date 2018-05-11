namespace :db do
  desc "Fill database with sample user data"
  task populate: :environment do
    make_users
    make_teams
    make_user_team_relationships
    #make_matches
  end
end

def make_users
  User.create!(name: "Example User",
               email: "example@test.org",
               password: "foobar",
               password_confirmation: "foobar",
               admin: true)
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@test.org"
    password  = "password"
    User.create!(name: name,
                 email: email,
                 password: password,
                 password_confirmation: password)
  end 
end

def make_teams
  40.times do |n|
    name = "Team - #{n+1}"
    Team.create!(name:name)
  end
end

def make_user_team_relationships
  base_team(1)
  base_team(2)

  38.times do |i|
    n = i+3
    r = [*1..100].sample
    UserTeamRelationship.create(user_id: r, team_id: n, captain: true, accepted: true)
    rv = [r]
    5.times do |j|
      r = ([*1..100] - rv).sample
      rv.append(r)
      UserTeamRelationship.create(user_id: r, team_id: n, accepted: true)
    end
  end   

end

def base_team(team_id)
  UserTeamRelationship.create(user_id: 1, team_id: team_id, captain: true, accepted: true)
  rv = [team_id]
  5.times do |n|
    r = ([*1..100] - rv).sample
    rv.append(r)
    UserTeamRelationship.create(user_id: r, team_id: team_id, accepted: true)
  end
end


def make_matches
  100.times do |n|
    n1 = [*1..40].sample
    n2 = ([*1..40]- [n1]).sample
    Match.create(team_1_id: n1,
                  team_2_id: n2,
                  finished: false)
  end
end