class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v30.7.0.tar.gz"
  sha256 "94fb2b8de8c80526e9f76fbc039a652ac9b13b074947c404293f5c9260c478e4"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec75c0240ec11ededf253f24c07402f663615001ef6d6b0eb664808872bd51e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2774843d4a1ed52ad40363e5d8d5d6a2c89faf30ddd6caf17c2d4aaa81afd899"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "805658a064494d3db00346066239887e9354517b9fc9df572d4f9206a572921d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4d71a8e44287dc37c3181849f7d48aed22bc0dbd6cf151bd30c79bdad163e84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "427522fa8eb3b88800330c8981196b9da09129d8c97b9a3c8f498681018481b9"
    sha256 cellar: :any,                 x86_64_linux:  "a3b2c618e8ea83e098c700ed22d68cc2dc2714aa4326e060b149808cd08f9266"
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