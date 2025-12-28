class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v28.6.0.tar.gz"
  sha256 "b81df2afaa88ac504f11d463c7cfef2c86b52ca90c70e37edf51da202734fc4a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56bf9decc5bea79934067085efedfddc3adc0c4bbc52c117a308ca22fe253a13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c14a4badd1aa4db15a70aadadd95a5add8f7e1f45c906b60f9c2a762fe3641fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d85ff9ef65779207a61332bb3b3aa12cd48eba7b79f570d88812b6cb75235e28"
    sha256 cellar: :any_skip_relocation, sonoma:        "09c214e3d3aade5698f3f3f6ee753bbbba88c1be55e03121aae5b3eefd3f84b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89c615ca611de475d303d0917de6ee9cf5153d292f53727ea6020a71fe9d0605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9db6838304901e2378b9fb8251347655020c7daa4ef37d144d3cfd8e1ccd065a"
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