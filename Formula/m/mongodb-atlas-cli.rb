class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https:www.mongodb.comdocsatlasclistable"
  url "https:github.commongodbmongodb-atlas-cliarchiverefstagsatlascliv1.34.0.tar.gz"
  sha256 "8151c413e8d9e6dd1657b4d642af460f20ffe04032676ab2152328c9358b0e2a"
  license "Apache-2.0"
  head "https:github.commongodbmongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0122cc44bd29bdd178988dac127584587705b49e0301034bc570f1d86e22c873"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4215609913c432d69e4b3a204b2cedb67a864f2d6e13e0d3eb1e53c5df4702a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16b56711b9f7f1ea72e1e257f29f8dcc4e2475826ab90c99cf5ebe78594a5f50"
    sha256 cellar: :any_skip_relocation, sonoma:        "efbd314ad40d8b76622e33105b178288d5068843b4ce9118c81ab366af6d2250"
    sha256 cellar: :any_skip_relocation, ventura:       "cbd46a307e6d1175a379c65c73a39deb91f65ff00541da8139fd87c7781d4b7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b83d15b2b88e81e53427254ecf890ab35ce7d9862770b76c4fe6e37798662bdc"
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