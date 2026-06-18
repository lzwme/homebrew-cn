class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.694.tar.gz"
  sha256 "c00aaab3d96364e6b2c56a8367a2b0aeffdbaaf4e76266c214b8582d7dbd9d46"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6b862b285d5db8b3e686276185b6ca0a4926f2fc71f504b9a78691c67f9a97c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bee635cf686b98555d82a1c366b0cce091c7acbc783f8adc90a2062ebe33536e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63f392b3826743e0f23f194d6082933fb7d7d0aa766906d65c4433a30dd0eaf5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e14d6fbb134f9a5ba3018b4fd8c6dc9b32c085c52f49dd7a006afeb9dd8262ee"
    sha256 cellar: :any,                 arm64_linux:   "e80399d1aa93d33f5868d1e78e334e7ea9fd5c084f393f2313480f467228ad23"
    sha256 cellar: :any,                 x86_64_linux:  "bd32e3a34a5ad53ccbcb406a0b7f1186ca8c870c09080f3c24d8ae105da1eb72"
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