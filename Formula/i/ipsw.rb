class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.667.tar.gz"
  sha256 "fafa6854f68bf715a7c920f261276db7325c124b8d6fed4e033ecf8eaa26060f"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60166465a61a181644c493fee5b2f17c100323ef79bd0033d437c07540ec8e96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4631cdca0bd620456def8f9e4d7e9dbbf25bf544d84121f9bb9f26937582175d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97f5886abb8447fee0c1735865e0f9e932e8aba50b0d5d17fd19f3da68ee84c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "aec02ca3cc7384d2ad403b88ebcd1bc36c2e8544585361cf72ae0b97e6778663"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5acfa283d1337deb70b94ee5d280f1c6cc57e5bdd0bdfa37cfd919a0650ff8ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32071f370fd47a9f8efe1993986803bd106591cba28e8d4db63580537277c95c"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipsw version")

    assert_match "iPad Pro (12.9-inch) (6th gen)", shell_output("#{bin}/ipsw device-list")
  end
end