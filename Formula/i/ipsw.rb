class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.629.tar.gz"
  sha256 "ff09559e87a7f9849897292ebfd71284ec560b02fec688634b0feb673454573d"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8d9f92f9510fd753798a534db02c478348e3a65b5ed6a7c1799d0a92b2cc9ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a67f2527ea7ecb470df1621d15c604eeca84857f6bc35d229ce8c417e24d9c19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9971793f55f9c002a2a2a3e399790d019180bba7139270d797c371b9bceb146c"
    sha256 cellar: :any_skip_relocation, sonoma:        "eab7c2845c912b62cc6fa1b88c02f8d56330dc131908cb4357304f2a8575b252"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcb44e9d33926ed9292312937804491b8721e1f09c74ddec639b55ac0b2ad7fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c12a4f800b92818a1bbd2ff521ffc2f42080922d899861542e07d80c0ab58341"
  end

  depends_on "go" => :build

  def install
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