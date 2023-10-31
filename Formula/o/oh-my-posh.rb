class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.18.1.tar.gz"
  sha256 "e566e0678470efa8097c1c7b71a01deaed7b072e38ac811289a004bbfc706f30"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "edb9c7fde17370815215a3db6e04325201f9280560baf0faaf1e801f34df5102"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aed488a1ad6fc2e93ee309a3f41ab54fa9a0d8005b618dee2f9f6b16e0b26b3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f08aab31a50f49ef4f91d648e5eea960c487442d7bc1e814629c698f048ce5ad"
    sha256 cellar: :any_skip_relocation, sonoma:         "437c71533bb63fbd95ed31681d0d19640fb8b78756e77f468886e3b1017a9642"
    sha256 cellar: :any_skip_relocation, ventura:        "dcc75c51ef1de1ffbc4f97bb1c201da6510362f57ec4ac4f47a8ded08e8fa9ed"
    sha256 cellar: :any_skip_relocation, monterey:       "d070eff22d76b244dc5ac52de4e5ecc56aa5f7d0da6c9ba33bba2b17f82abe7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f88480befbf748b06fa5d7083359c3b109d7b5625cac7fe2e573c70b244e5fa"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end