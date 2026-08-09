class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v30.6.4.tar.gz"
  sha256 "d5878036b14e39f1d21ba7f46a47a83820b382d6ac00d5ec105acc072641cf35"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2931811f04e3572a42200b4295584356263a72841d80e8e5e2b73269763edb1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e771ab3b60d388945b697a0c1e176e4fdc9f75a81fb79e6a274f1a9571398710"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2863d1b99633962336f7181f1c199deee05ded1ccf5f3c1f25fc753a0c0bb2c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b3c3c5c32a9192a70a2e1869464cf25621eec1ffffd022b0520e6b174b26b06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87293690ade1f6e36820c978e9b55457c4d192f7dae97eedc5a17a354f0e18cd"
    sha256 cellar: :any,                 x86_64_linux:  "9b3f0a74cfba347e1e02caf590927730b677a837a1d413e6c00b7d2f53d10a76"
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