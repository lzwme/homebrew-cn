class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.5.0.tar.gz"
  sha256 "d14d665a2dd767116b6b5f66e5e195ac86ac940ff782af712575da6267063b84"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a611c3d401ca3648fec2fdf2fa500f97fe96241b371c137af354feb48a74dc1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3a1c994a5630951fb974b1919cd1c8d18a42f8168361e43afab2c154c9e2ebe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba57e2362b13298dfcdf3ffdcd552af818638fe8b1bf8e64414f2b66575e6350"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad733b25ed15d617a455bccf916a3be788322481730f18d4a5aca00fea11ffb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1b59c3f3a34259b3d88a005350863665af6000ec9e6f5ea3ab7acdd59d0a2b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd1514628f38d3cd8c922ee87ff091e141e6b7f9029f72e0f6fad903786eb5a3"
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