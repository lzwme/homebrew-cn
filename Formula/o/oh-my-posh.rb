class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v31.2.1.tar.gz"
  sha256 "19d8d17995d01291c3bc922074cea973659b0899b5e4d6bf1e3dabe6691bcf4e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74a42ef21fd37ab1db0d8f4d6aadb8f77b3afc5719b5c57f98eb009ee3ec29ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1413cb26918f71282501f726749c8e34fba5131d0fbf5d7be579ea20a69f87e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6560b38be02f77b121551ce3d81f02a98139b6c3a70f56faa06eefe9f51333ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c64271b44e96b60b786b716b52280cf23b92f2b513ee70edb9238a17f1d48178"
    sha256 cellar: :any,                 x86_64_linux:  "10a7b0df1986cc3fe999a0403849ce7a3ff3103f60154551d5a2010ca3da5afa"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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