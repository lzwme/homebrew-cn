class HapiFhirCli < Formula
  desc "Command-line interface for the HAPI FHIR library"
  homepage "https://hapifhir.io/"
  url "https://ghproxy.com/https://github.com/hapifhir/hapi-fhir/releases/download/v6.8.4/hapi-fhir-6.8.4-cli.zip"
  sha256 "836eb2c6e6dffadddefa50b2d22f51ec057bf7e75de21a882c83dd0757114d49"
  license "Apache-2.0"

  # The "latest" release on GitHub is sometimes for an older major/minor, so we
  # can't rely on it being the newest version. However, the formula's `stable`
  # URL is a release asset, so it's necessary to check multiple releases to
  # identify the highest version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "599ec32d59a73988336769167534038495b4107678a7db06d87ed0acb28906fc"
  end

  depends_on "openjdk"

  resource "homebrew-test_resource" do
    url "https://github.com/hapifhir/hapi-fhir/raw/v5.4.0/hapi-fhir-structures-dstu3/src/test/resources/specimen-example.json"
    sha256 "4eacf47eccec800ffd2ca23b704c70d71bc840aeb755912ffb8596562a0a0f5e"
  end

  def install
    inreplace "hapi-fhir-cli", /SCRIPTDIR=(.*)/, "SCRIPTDIR=#{libexec}"
    libexec.install "hapi-fhir-cli.jar"
    bin.install "hapi-fhir-cli"
    bin.env_script_all_files libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    testpath.install resource("homebrew-test_resource")
    system bin/"hapi-fhir-cli", "validate", "--file", "specimen-example.json",
           "--fhir-version", "dstu3"
  end
end