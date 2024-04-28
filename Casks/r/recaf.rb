cask "recaf" do
  version "2.21.14"
  sha256 "8d14fc007e2a90a0d2331e5170cfce0f899ad96631aa7565623dea997c6bcb84"

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