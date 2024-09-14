class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https:www.mongodb.comdocsatlasclistable"
  url "https:github.commongodbmongodb-atlas-cliarchiverefstagsatlascliv1.27.1.tar.gz"
  sha256 "64202763bc4558af12238a05b6c86296af155dd9355f60a9542c2df07fa5dfbc"
  license "Apache-2.0"
  head "https:github.commongodbmongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d61e2fd38a1afabedd8cf6b051379a9db80e8c66982a110237bf50989910db7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54b9d09e71d5848020a47912ec4f601d28f5b5f426565736750ef5d3e4487bfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b92afaca2a3ced11713bc4af9019c5458e233ef0fc13e00069cfc493f728460"
    sha256 cellar: :any_skip_relocation, sonoma:        "f816ee549eff83d922dcbf9068cc8817fbad3bd35edac996543b69123b8d3f86"
    sha256 cellar: :any_skip_relocation, ventura:       "bdc5ced3354f20c2a0ed14575af600f552d8750f45c11cfd54b5108639a5d179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adbbbbe25aa270051f223d71592be1758a4f3491cb1c5e4a4a6f6f2d0db5724d"
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