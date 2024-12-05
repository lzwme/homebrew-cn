class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https:www.mongodb.comdocsatlasclistable"
  url "https:github.commongodbmongodb-atlas-cliarchiverefstagsatlascliv1.33.0.tar.gz"
  sha256 "2dad874db2c4022630ed78a7b1f9b820264aa4521979f76901f55a80d3b8ce45"
  license "Apache-2.0"
  head "https:github.commongodbmongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "982a759ab263980b7a3ca0270bd27f7712e6a098fa6fa69c3c3d5690b30ce250"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8d4fb1bff59739cb66b6dbfce90e29c4b66f7ba0b27860d5f5366ab28772893"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca9350038cd6b3d7295ae45c30a66780e3e6d82f74b8a7ca0d5f1251536b18ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f02410e3d48ea64fb6614221475c18bd997818d43b055cbb41d8c52d80537c2"
    sha256 cellar: :any_skip_relocation, ventura:       "620d4245501e69408ac4ed3e6b282213d3b93b82fdfe90d37f31add144ecedea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "884c28f81fa76ff512a7229f82d2eaf1b8ae7d399ba3c13e97fb4e1e3d72b7e4"
  end

  depends_on "go" => :build
  depends_on "mongosh"

  conflicts_with "atlas", "nim", because: "both install `atlas` executable"

  def install
    ENV["ATLAS_VERSION"] = version.to_s
    ENV["MCLI_GIT_SHA"] = "homebrew-release"

    system "make", "build"
    bin.install "binatlas"

    generate_completions_from_executable(bin"atlas", "completion", base_name: "atlas")
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}atlas --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}atlas config ls")
  end
end