class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v30.9.0.tar.gz"
  sha256 "1f883716db56729bc2c97703673758892917502a81e844e2f6305067ebf968ce"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38d439cd1dd06068366d48d70f58bb924027390a5f7cb2a57b1909f5438286a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5ef16d3020d63a1534937fd92da39f954070ac03a9fcac487178b87588e44cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f71229b83e4db7267432ac068bd466a3428b6d734ef34057cc67a76417a1e42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51afca90891038c4404b1d1d3d229995c14cd400a475d02b1b97b622cfe6a5ec"
    sha256 cellar: :any,                 x86_64_linux:  "3e60c50f93b81f01525409165ca59374a980d3d0d5995bedc3b75b757bdc8afc"
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