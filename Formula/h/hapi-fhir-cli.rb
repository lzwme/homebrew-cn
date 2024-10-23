class HapiFhirCli < Formula
  desc "Command-line interface for the HAPI FHIR library"
  homepage "https:hapifhir.io"
  url "https:github.comhapifhirhapi-fhirreleasesdownloadv7.4.5hapi-fhir-7.4.5-cli.zip"
  sha256 "f768110b57f6b31a42bf35a93257166d955be2a176a1c54ed8911930ce78f8b5"
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
    sha256 cellar: :any_skip_relocation, all: "32bf7574e12b0265b8150b53456237a370ef7c40ec2f53338257f4455f58b340"
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