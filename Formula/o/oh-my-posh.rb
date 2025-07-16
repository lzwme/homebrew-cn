class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.15.0.tar.gz"
  sha256 "9a9e12cf95cc3419957fe8194a21eaae11d030fe3fb16b8fd2f739d593b0c1f5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0de4e7a236a45f57dfb0cfd1a19359c71bf4b7ad979fe8f3806ef1787cc628a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "688a8f0ff0440b9e777124a3b6bb88b70fe477ee0c2240ab7cdfc64a9ee1fbe8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "012cb44c252c1ac27f7e06cd0a3983588de24947041cf596bca4aac4520a3f98"
    sha256 cellar: :any_skip_relocation, sonoma:        "d774f0648954ceddc85c159cffb5668ba5a401dc183bb88b6286a3eeae1a47ad"
    sha256 cellar: :any_skip_relocation, ventura:       "3ea8fa29108b4d15cd649d8622c5a783db384bdb7782411b10d0d3096b777ddb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80ac60124cb013b97bb0911c8970739500a4c7bc092eb097929e2dda51a292a0"
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
    assert_match(%r{.cache/oh-my-posh/init\.#{version}\.default\.\d+\.sh}, output)
  end
end