class HapiFhirCli < Formula
  desc "Command-line interface for the HAPI FHIR library"
  homepage "https:hapifhir.io"
  url "https:github.comhapifhirhapi-fhirreleasesdownloadv7.2.0hapi-fhir-7.2.0-cli.zip"
  sha256 "cf0a83a05fc1b6dc7cebcc144966c1bd6a65743d8adf990ac6d6c64ef52da38e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "802bf458afa217b89e5515e137e50eba822e5d1aa877e59ba33004e8ccedb43b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ac6de85b13b87f50338718652f9b75d3f54caee6bd49fe9d363dbbb6d904d06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46cc27b6c55fb4c50a8c22e9c4ed377d9712f6a84eefa760ba1b561280d4ddf1"
    sha256 cellar: :any_skip_relocation, sonoma:         "5de232be864f33202d5cb76027d40a8a18b85afed6c45c7f0d181afb4601bc7d"
    sha256 cellar: :any_skip_relocation, ventura:        "c83b889db81a7b7642adc1e46006653e1e728f38fe3ede3a8873555ac6723d94"
    sha256 cellar: :any_skip_relocation, monterey:       "9d10cbd86d3b89a90fb4919be23f6bcebc50f32ed055c92b8f297a3527b3d94d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c42586107a912e3b41426b7aedda36917bbcbae0ec8b080cd74cecf2d194adb"
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