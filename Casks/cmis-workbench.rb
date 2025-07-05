cask "cmis-workbench" do
  version "1.1.0"
  sha256 "c513d4568d6fc5631c82208c734f718e600ca694cf7b22af1c164bee07e70dc4"

  url "https://archive.apache.org/dist/chemistry/opencmis/#{version}/chemistry-opencmis-workbench-#{version}-full.zip"
  name "cmis-workbench"
  desc "CMIS desktop client for developers"
  homepage "https://chemistry.apache.org/java/developing/tools/dev-tools-workbench.html"

  depends_on formula: "openjdk"

  # shim script (https://github.com/Homebrew/homebrew-cask/issues/18809)
  workbench = "#{staged_path}/cmis-workbench.sh"
  runscript = "#{staged_path}/cmis-runscript.sh"
  binary workbench, target: "cmis-workbench"
  binary runscript, target: "cmis-runscript"

  preflight do
    File.write workbench, <<~EOS
      #!/bin/sh
      JAVA_HOME="${JAVA_HOME:-/usr/local/opt/openjdk/libexec/openjdk.jdk/Contents/Home}" exec "#{staged_path}/workbench.sh"  "$@"
    EOS
    File.write runscript, <<~EOS
      #!/bin/sh
      JAVA_HOME="${JAVA_HOME:-/usr/local/opt/openjdk/libexec/openjdk.jdk/Contents/Home}" exec "#{staged_path}/runscript.sh"  "$@"
    EOS
  end
end