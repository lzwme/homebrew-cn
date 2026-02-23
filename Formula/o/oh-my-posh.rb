class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.6.1.tar.gz"
  sha256 "717eb60bf8f22ef425ac7784b7533d5a057642f920957d1c7efad2ea4ae1f724"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffc681cebdf5255eb6474b6f345342a298040bef47f9e98d9dbcf9b4fcb345ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cb283349ea2a54652572770b1abe4df1ebf70a2086459246be37f146ff64e8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17c922f8b45093aadd01418a4af746b14934314ff1ffeffcd8b1372b960d420a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e6b3101dd9b7b233db5f0f5c76576bcc301e67b479669a2697ac1e98559ed2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87e1e1ae1f3c752c09376edf1dc5f9adb6b24d259cc0c2e0d5e06b391563ad17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3d3e939d193a70be1d0485d9bd9559efab46e9c57c7376fc8cded5691bdfe6f"
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