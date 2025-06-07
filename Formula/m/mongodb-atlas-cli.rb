class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https:www.mongodb.comdocsatlasclistable"
  url "https:github.commongodbmongodb-atlas-cliarchiverefstagsatlascliv1.43.2.tar.gz"
  sha256 "89be7e6cecd3620b73d257b710b9b2dbe04ce16bfd28adf4c656ed94968520ac"
  license "Apache-2.0"
  head "https:github.commongodbmongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be152000ec7a0581b1d39ddc85d45ee949a456bdb388823174974fce72725a77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52dac8aa2eaf5bde08d853e7120acc8aa6ba81fec0cf52b3386e8cba3cbe2d47"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc2e5fda12df7e6319523cfc54ab11442af88c7242a01da035bdd16405d55907"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0ee174fc78e6527487d0f74a22b9108092cb399b6e38eb08412641af5a0420c"
    sha256 cellar: :any_skip_relocation, ventura:       "73bfda2353410b897b3b88d6e4cdb02e53266ea0835d1cb51367814327bc52ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15c176f9a3489f2999ff96b522b838057671574775bca1f360e35ce444fc0710"
  end

  depends_on "go" => :build
  depends_on "mongosh"

  conflicts_with "atlas", "nim", because: "both install `atlas` executable"

  def install
    ENV["ATLAS_VERSION"] = version.to_s
    ENV["MCLI_GIT_SHA"] = "homebrew-release"

    system "make", "build"
    bin.install "binatlas"

    generate_completions_from_executable(bin"atlas", "completion")
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}atlas --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}atlas config ls")
  end
end