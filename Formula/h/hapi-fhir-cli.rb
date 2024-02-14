class HapiFhirCli < Formula
  desc "Command-line interface for the HAPI FHIR library"
  homepage "https:hapifhir.io"
  url "https:github.comhapifhirhapi-fhirreleasesdownloadv7.0.0hapi-fhir-7.0.0-cli.zip"
  sha256 "5e05b7e43c4b9f3ff22633f90c62f7dc24fbf0471b2b060b0a21fdb5f5275a8a"
  license "Apache-2.0"

  # The "latest" release on GitHub is sometimes for an older majorminor, so we
  # can't rely on it being the newest version. However, the formula's `stable`
  # URL is a release asset, so it's necessary to check multiple releases to
  # identify the highest version.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7121423790d0fa1074a89f648f473e93f92ce188415f5c6105109a69ced01a8a"
  end

  depends_on "openjdk"

  resource "homebrew-test_resource" do
    url "https:github.comhapifhirhapi-fhirrawv5.4.0hapi-fhir-structures-dstu3srctestresourcesspecimen-example.json"
    sha256 "4eacf47eccec800ffd2ca23b704c70d71bc840aeb755912ffb8596562a0a0f5e"
  end

  def install
    inreplace "hapi-fhir-cli", SCRIPTDIR=(.*), "SCRIPTDIR=#{libexec}"
    libexec.install "hapi-fhir-cli.jar"
    bin.install "hapi-fhir-cli"
    bin.env_script_all_files libexec"bin", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    testpath.install resource("homebrew-test_resource")
    system bin"hapi-fhir-cli", "validate", "--file", "specimen-example.json",
           "--fhir-version", "dstu3"
  end
end