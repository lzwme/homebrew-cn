class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.623.tar.gz"
  sha256 "113c36c58c1575fce39dcc4d51eefe8f6b227a87ee80bcdaf3d4abdfaa21d294"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5443a870f6eb75602db9fa625171d5903ec69d560ab52d16b4f144d3148ef0f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a0c0bd8f4661aea75c578f2d0350df6f70db0f4f78c4a7638e5c924bc8fef31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abfd619d4193eba8c762cd0b818babf38404b035a9ac7f65fb3017505c4105d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "711e3f27e21684015307cb9e93749142e406ff45084b4ea9eab55d362dc7f628"
    sha256 cellar: :any_skip_relocation, ventura:       "03cedbe0d0a404caf1779207460cfc2433c3a74aff22b5d1b905b6787765324d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "084b4c70a057343bbcb3af37c88f01313b3579300bdf8374af40d18fa3cd0bc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dc84c8103cfc8fc69a4c39bf7825556bf5171f73600babf8a252f49adf78aee"
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