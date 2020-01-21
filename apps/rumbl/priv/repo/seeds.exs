alias Rumbl.Multimedia

for category <- ~w(Action Drama Romance Comedy Sci-Fi) do
  Multimedia.create_category!(category)
end
