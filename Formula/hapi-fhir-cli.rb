class HapiFhirCli < Formula
  desc "Command-line interface for the HAPI FHIR library"
  homepage "https://hapifhir.io/"
  url "https://ghproxy.com/https://github.com/hapifhir/hapi-fhir/releases/download/v6.6.0/hapi-fhir-6.6.0-cli.zip"
  sha256 "4e8aa1fcede745dafc7cc13f07cb39f2ac3bc063ab934141502b3414e4702191"
  license "Apache-2.0"

  # The "latest" release on GitHub is sometimes for an older major/minor, so we
  # can't rely on it being the newest version. The formula's `stable` URL is a
  # release archive, so it's also not appropriate to check the Git tags here.
  # Instead we have to check tags of releases (omitting pre-release versions).
  livecheck do
    url "https://github.com/hapifhir/hapi-fhir/releases?q=prerelease%3Afalse"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cb71663dc48ddb9db9206b61a57965093180eab9346d2f002633b2c3cd7bdb46"
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