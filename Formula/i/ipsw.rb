class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.650.tar.gz"
  sha256 "81918d6fab4659ddc6132fd19f0918ed7f354e6eda7683b47b9a523a5daea7f3"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79c159308e81f580458ae7b2f514551ecd0f34771f6544f7f83fb78edb9e01b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71d0edc0288d4a0fc864074f91ebcfa201f02461aa4c8f1457f2e22f727e9099"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed6e2868d03b3dc499ce901e59c98b5c20f7e0bfa14aed8d7b7fff6310b18f5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d16f473316a933b5df2280f6c7688125cca2d45bb9bd069e943e91e310184819"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb94912d62a87f64610a793866a0119ffd72749c40759035bddcfc66b973ac6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a34d92db858aedeb4fac3a6f10d940b068c8107954ca00253fd16650e5cc26a2"
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