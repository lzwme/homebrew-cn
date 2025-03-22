class Chainhook < Formula
  desc "Reorg-aware indexing engine for the Stacks & Bitcoin blockchains"
  homepage "https:github.comhirosystemschainhook"
  url "https:github.comhirosystemschainhookarchiverefstagsv1.8.0.tar.gz"
  sha256 "5d1ea1ad91585d440cf56d0293541593294b70cbf59172957ff53b5598be874d"
  license "GPL-3.0-only"
  head "https:github.comhirosystemschainhook.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ee1d70019ceef4495f0921b1344b12b092846010ba7d831cfbae5f3639e682c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d84022e09a8266a52686ed6c8ecda900051f13a4cc848daa0f6c518337cbb3ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a30eb3a6b72c2c0cdd41d65f55f8b4317d1261b07fbcceca6363b39bef1ed7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0e6da7d2520a8954d52270dda75248be81de3ff667ce6489b76a75d94d20ee7"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e99210c74407049e8ea75816c0fb3b1ca111ca056c2f95ee923c8202dedb7cc"
    sha256 cellar: :any_skip_relocation, ventura:        "2d5f0d818bd4abb96efa88b7200ea9f3532169eca622e07f61d50a9fc7e4f92a"
    sha256 cellar: :any_skip_relocation, monterey:       "213dea4d00349141619d2682bee6191d18aaeeb5aa99340599f54dab75abb521"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "10d4381a6b4bc83b5f1ef41fd88c6c1d9da90e820e95d9f86c2a25b87c1a9666"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1baa3948cbd9735f9249af29ff40e21d005185c70dd0f2a023cc733e298505f3"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  # rust 1.80 build patch, upstream pr ref, https:github.comhirosystemschainhookpull631
  patch do
    url "https:github.comhirosystemschainhookcommite98fc6093e30c41aec55a3391b917ff92de6df1f.patch?full_index=1"
    sha256 "9b1b48a9a5be5ae0ceb3661c7e61f08ca6806ee49fd684dd1dc29cc3a3abb242"
  end

  def install
    system "cargo", "install", "--features", "cli,debug", "--no-default-features",
                                *std_cargo_args(path: "componentschainhook-cli")
  end

  test do
    pipe_output("#{bin}chainhook config new --mainnet", "n\n")
    assert_match "mode = \"mainnet\"", (testpath"Chainhook.toml").read
  end
end