class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.683.tar.gz"
  sha256 "f079ac8c53c02e78567099c85a70a7b886a7f774525f8e0e6211bb26614ea584"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c28c3306b1dd9e6204ccb09cbc3d887ff7d2671f3dc317d1e79ebd167074cd03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c59daecb0ad184c00bed660dd4a9d41677ef3868e4a97d49738d1f731a6eef2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d017f8c3fcf67276ef964f45b0f82aecca8a9f8a87c0611e91ab706d2515806c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f727eee873bb250d7732a84fcf9946baa5ff1a832e839b91a2ccc1979d23181"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2c015dffee19980313e288b94109843c90e6d9a1e48add722573e1da7b48290"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e391896baf3f4ef12483236a1c70a12ef4020fbe19404fa08973abb967194210"
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