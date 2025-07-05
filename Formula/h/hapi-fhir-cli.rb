class HapiFhirCli < Formula
  desc "Command-line interface for the HAPI FHIR library"
  homepage "https://hapifhir.io/"
  url "https://ghfast.top/https://github.com/hapifhir/hapi-fhir/releases/download/v8.2.0/hapi-fhir-8.2.0-cli.zip"
  sha256 "c02e85e6cafb85d458d3dac497cb6a75d66d7fc69fa8a4779e9b64afb22e94c5"
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
    sha256 cellar: :any_skip_relocation, all: "25a7ecac53b111b1e2b19e729b3801832a9d98735ebd14ca86338ef8d1ef30d7"
  end

  depends_on "openjdk"

  def install
    inreplace "hapi-fhir-cli", /SCRIPTDIR=(.*)/, "SCRIPTDIR=#{libexec}"
    libexec.install "hapi-fhir-cli.jar"
    bin.install "hapi-fhir-cli"
    bin.env_script_all_files libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    resource "homebrew-test_resource" do
      url "https://github.com/hapifhir/hapi-fhir/raw/v5.4.0/hapi-fhir-structures-dstu3/src/test/resources/specimen-example.json"
      sha256 "4eacf47eccec800ffd2ca23b704c70d71bc840aeb755912ffb8596562a0a0f5e"
    end

    testpath.install resource("homebrew-test_resource")
    system bin/"hapi-fhir-cli", "validate", "--file", "specimen-example.json",
           "--fhir-version", "dstu3"
  end
end