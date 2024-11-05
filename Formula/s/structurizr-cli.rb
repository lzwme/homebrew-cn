class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https:structurizr.com"
  url "https:github.comstructurizrclireleasesdownloadv2024.11.04structurizr-cli.zip"
  sha256 "5c4e9ded37501450da642fdb112607cf6ad5a5e2d17be6454571d50675d90361"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "19340dc955170ef3a78b2005896c37905cb44ad5cfb28e1caae9c0450ebd7f13"
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