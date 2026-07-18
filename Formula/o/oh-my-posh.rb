class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.32.0.tar.gz"
  sha256 "2858c27dc799270792ea212ace39324c41f3e1530928409599e65ad44b4b4014"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9544cb37dbf5a630f8a2af0d02578f97b81a62bbd37b0eb00b908aad032753d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30c3ed1c688e830dc0bdd50d6f6be893170b99cff124b59a389f1b5e31e3b96f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91a97c9b18210428f7a4cd2ad78c07d81e60efc8c022dd884b021cc42abd036e"
    sha256 cellar: :any_skip_relocation, sonoma:        "98774b4633cc920e526d354077a8dec804c8a287b99f1053ed4144417cd49310"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "214ad1f8cf0f851f9077a297215e31065b75204f341fa5575c9a2179c1e04d87"
    sha256 cellar: :any,                 x86_64_linux:  "bec3d85a965fb02569c785abcb24c628710f586696fc4fcb655209d1da06bf50"
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