class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.632.tar.gz"
  sha256 "a6e16a3d99802ceb942d7b9e6f0c25b91ff98c2f41d5009a5470d49aab9c18df"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46983ea938c71a95ce8712da2dbc654349cff685b7376bae76b9dc9229f6acdc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ada541c222b1a769157b675a502aba146016b58885cfdd94bc21aecc157cee9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11546308d44809af617afb9708ccc5703fddf32b75e5f45b80da9538dc9f5c43"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2017c81d3577b7942052466656824283f6661d117ba1fa40eaca2f080277903"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34e1c3bb5b251f9006a110fdf30b92774e6497d1bddd7ea9f0daffb4537e0650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4748d13713220bcee7bd4e2dc4a3d4a5f879578bd1aa077c728c75976a33b978"
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
    generate_completions_from_executable(bin/"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipsw version")

    assert_match "iPad Pro (12.9-inch) (6th gen)", shell_output("#{bin}/ipsw device-list")
  end
end