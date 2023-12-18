cask "double-trouble" do
  version "0.90"
  sha256 "c38766806c717093610bb73f9c23218bc430c4b6bdb20b3e99910c5c9d1a454c"

  url "https:github.comnicerloopdoubletroublereleasesdownloadv#{version}DoubleTrouble_#{version}.jar",
      verified: "github.comnicerloopdoubletrouble"
  name "double-trouble"
  desc "Scans directories for duplicate files"
  homepage "https:web.archive.orgweb20040624080055http:folk.uio.novidarsk"

  depends_on formula: "openjdk"
  container type: :naked

  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}double-trouble.sh"
  binary shimscript, target: "double-trouble"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      export JAVA_HOME="${JAVA_HOME:-usrlocaloptopenjdklibexecopenjdk.jdkContentsHome}"
      exec "${JAVA_HOME}binjava" -jar "#{staged_path}DoubleTrouble_#{version}.jar" "$@"
    EOS
  end
end