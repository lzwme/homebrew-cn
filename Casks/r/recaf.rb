cask "recaf" do
  version "2.21.13"
  sha256 "9d6cff1f9d4a7363027f53f4e85c8b74e235a2884463b7475fc1b83aee2d000e"

  url "https:github.comCol-ERecafreleasesdownload#{version}recaf-#{version}-J8-jar-with-dependencies.jar",
      verified: "github.comCol-ERecaf"
  name "Recaf"
  desc "Java bytecode editor"
  homepage "https:www.coley.softwareRecaf"

  auto_updates true
  container type: :naked

  # Renamed for clarity: jar file name is overly complex
  app "recaf-#{version}-J8-jar-with-dependencies.jar", target: "Recaf.jar"

  zap trash: "~LibraryPreferencesRecaf"

  caveats do
    depends_on_java "8+"
  end
end