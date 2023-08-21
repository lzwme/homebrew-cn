cask "double-trouble" do
  version "0.90"
  sha256 "c38766806c717093610bb73f9c23218bc430c4b6bdb20b3e99910c5c9d1a454c"

  url "https://ghproxy.com/https://github.com/nicerloop/doubletrouble/releases/download/v#{version}/DoubleTrouble_#{version}.jar",
      verified: "github.com/nicerloop/doubletrouble/"
  name "double-trouble"
  desc "Scans directories for duplicate files"
  homepage "https://web.archive.org/web/20040624080055/http://folk.uio.no/vidarsk/"

  depends_on formula: "openjdk"
  container type: :naked

  # shim script (https://github.com/Homebrew/homebrew-cask/issues/18809)
  shimscript = "#{staged_path}/double-trouble.sh"
  binary shimscript, target: "double-trouble"

  preflight do
    File.write shimscript, <<~EOS
      #!/bin/sh
      export JAVA_HOME="${JAVA_HOME:-/usr/local/opt/openjdk/libexec/openjdk.jdk/Contents/Home}"
      exec "${JAVA_HOME}/bin/java" -jar "#{staged_path}/DoubleTrouble_#{version}.jar" "$@"
    EOS
  end
end