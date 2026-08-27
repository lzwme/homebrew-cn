class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v30.8.0.tar.gz"
  sha256 "45626ff3991172b2adc43ee7b071aa28965cda37da7cafdcfe121a4ff6f6a761"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17914bb2218e9bcf7ffbf9238c98490f61f588b0e0c5c809872bf32f8e63861b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e33709bc0f276c22764a69a56cd59c56fa76f54657e36c85e1022bd053cbb90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bb4e8f3c563223db77660613038798abb7da29be32df8da6af65e03ae13ff3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "dde2c090b9a0850de4f859aaed9b23eed2074513c2f010f040666a951233c66f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cabf101f76edf63e2fd4c6c486e966d97961528f8a61cb6d3d77bf980a5c618"
    sha256 cellar: :any,                 x86_64_linux:  "d6ec72a7aa711aafcba053f1a3efbe42caba3774426a017e25002f829adbde3d"
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