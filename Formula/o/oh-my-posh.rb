class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.2.1.tar.gz"
  sha256 "319c84e6eff3d51de49b627ec55c3bfdbbfa85eddff21862d8d1d1e4821fb47f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16382dd4e6999f5396c8908a7836fd215909bc0c3cf92f8af1b3fccc8145db49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c240340122a3abbe687fee0b37e6294b0037d48a611ce859cb2188df58d9ee6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6beb9e5cd3c88d9f93c7382cd4f14f5b64bbe9f2aa16cafab9d19f2574d04fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "6820e2526055dcbad7afdb6effcbf4fd6fb81e8a60737dbd61353aee66cf5ce8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e44ee4342196825c83f92525e790ec40dd5839b1f7ec40f7d773d760d69beee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07e9a7d79422bb56640508828faba9b2e7f839522e80f99d9365a0ebfa29725b"
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