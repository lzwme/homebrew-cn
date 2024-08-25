class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https:structurizr.com"
  url "https:github.comstructurizrclireleasesdownloadv2024.07.03structurizr-cli.zip"
  sha256 "d419e5221f3c8dbb1f92bda7420094905a1f6c651184dc49abb119f203de5e96"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "aa81f8a712c590e1176f764197aacafe8efb6ac5af9f2b9cb0ff3d529d463e67"
  end

  depends_on "openjdk"

  def install
    rm(Dir["*.bat"])
    libexec.install Dir["*"]
    (bin"structurizr-cli").write_env_script libexec"structurizr.sh", Language::Java.overridable_java_home_env
  end

  test do
    result = shell_output("#{bin}structurizr-cli validate -w devnull", 1)
    assert_match "devnull is not a JSON or DSL file", result

    assert_match "structurizr-cli: #{version}", shell_output("#{bin}structurizr-cli version")
  end
end