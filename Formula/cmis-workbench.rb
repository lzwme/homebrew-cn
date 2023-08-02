class CmisWorkbench < Formula
  desc "CMIS desktop client for developers"
  homepage "https://chemistry.apache.org/java/developing/tools/dev-tools-workbench.html"
  url "https://www.apache.org/dyn/closer.lua?path=chemistry/opencmis/1.1.0/chemistry-opencmis-workbench-1.1.0-full.zip"
  mirror "https://archive.apache.org/dist/chemistry/opencmis/1.1.0/chemistry-opencmis-workbench-1.1.0-full.zip"
  sha256 "c513d4568d6fc5631c82208c734f718e600ca694cf7b22af1c164bee07e70dc4"

  depends_on "openjdk"

  def install
    rm Dir["*.bat"]
    rm Dir["*.ico"]
    rm Dir["*.command"]
    rm "create-shortcut.sh"

    libexec.install Dir["*"]
    Pathname.glob("#{libexec}/*.sh") do |file|
      basename = "cmis-" + file.basename
      basename = basename.delete_suffix(".sh")
      (bin/basename).write_env_script file, Language::Java.overridable_java_home_env
    end
  end
end