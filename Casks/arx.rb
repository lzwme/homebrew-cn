cask "arx" do
  version "3.9.1"
  sha256 "d410f22b9146335f510ec3e084c4cc70a695c78e0571cbb41b27896e88c0ed55"

  url "https://ghproxy.com/https://github.com/arx-deidentifier/arx/releases/download/v#{version}/arx-#{version}-osx-64.jar",
      verified: "github.com/arx-deidentifier/arx/"
  name "arx"
  desc "Data Anonymization Tool"
  homepage "https://arx.deidentifier.org/"

  depends_on formula: "openjdk"
  container type: :naked

  # shim script (https://github.com/Homebrew/homebrew-cask/issues/18809)
  shimscript = "#{staged_path}/arx.sh"
  binary shimscript, target: "arx"

  preflight do
    #   Pathname.glob("#{staged_path}/*.jar") do |file|
    #   bin.write_jar_script file, "arx.sh", "-XstartOnFirstThread"
    # end
    File.write shimscript, <<~EOS
      #!/bin/sh
      export JAVA_HOME="${JAVA_HOME:-/usr/local/opt/openjdk/libexec/openjdk.jdk/Contents/Home}"
      exec "${JAVA_HOME}/bin/java" -XstartOnFirstThread -jar "#{staged_path}/arx-#{version}-osx-64.jar" "$@"
    EOS
  end
end