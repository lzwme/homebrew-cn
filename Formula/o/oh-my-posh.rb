class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.20.1.tar.gz"
  sha256 "0e044697f34be618f7f4f03a6def6e6c429262155d3ed7ab48e8d2ca1c2f6121"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4311813f7f4226539a207f40c9590771f1d4a419e6b6e413403c058cc53d6c7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b72ec936bdc93a3c52e37df1f7d1eeaa952109aa1dcf4e16f144e7a67142a732"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3b14612d1608a57ee1ac877ba2d5fc5a775e0ea922e96b26094526f693a411c"
    sha256 cellar: :any_skip_relocation, sonoma:        "83fb23f7dfe9ac1f2bb7493806002d1448c78233ae96e7062415241bb667c073"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1895da49911f5dfb00bfce241089252817744d3eb692b604dedcc5219eb63407"
    sha256 cellar: :any,                 x86_64_linux:  "993c5287a8d1bdc05e53297b07eaf6691b53cbb9462565cf69b3288e401f23eb"
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