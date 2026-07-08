class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.22.0.tar.gz"
  sha256 "54d0e3bb189549a3511ef3fd6b4a3bd91942085f5b3722855b014d0b38aee086"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f07dbc8556c3d4bd4bb53c861d0c761e38642b0a33b5ca8b64ad1cd6dbedcfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "555a7ec33bee47f89aa78de22fc6f4f79b2caddb5604a2bd47f11ff9a03331d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5574907686fda8b0202d51d938532857f857303df842a69498cf931f3a221ae3"
    sha256 cellar: :any_skip_relocation, sonoma:        "820f698509f2d04ec791883affeb5feb1456493456579098dc3cb038e1d4807e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1e0cec789827f207710443f8a1a83af67fe78f998286754578158d92da6cf9f"
    sha256 cellar: :any,                 x86_64_linux:  "f1c2d6fa82fb2b88ff19b5573d0073e6bd215a3a89d535c6b1c15ad46f69c9e4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end