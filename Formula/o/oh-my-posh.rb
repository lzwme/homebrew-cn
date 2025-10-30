class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v27.4.1.tar.gz"
  sha256 "1a304c38fd9711f0c7864defd666f44c5193a3de34be8b4bdc8676a98f7733d6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e99fbc1439ef48aeae4dbbf85907b8b5e8ba8790b4fb18d7087c1ff5a3d0e50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10bb52b7816778aa126850e724539b624445cc6a39912da3eeeba93a65c80ce5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dec637319514874fc98ef0555975ee9431a43a13905b956312affb51551cb2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e21bb6f449bf470c7130df483eac8c69e83ddd0b2ec2993ed28f943eb4f34a65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f40a55f4fb7d8502c126028eba0d11ce850303ccea0f3aa8cb59ea1f767fad21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3224632885d1d612f4cd418da2bdfd003981c72a0c05129d577de9851cdf85f0"
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