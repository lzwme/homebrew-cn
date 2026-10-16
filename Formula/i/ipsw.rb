class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.738.tar.gz"
  sha256 "7900c370dc1fd6b03f9b477df486cb9fd6466577a29534811279012475c60402"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b7c4e9d68db1574da45541218549e5b55c2e93dc038937eedc414d3dcd054675"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "da7e6a9ca627c1522d37acbed7ac6a9cdf9549eec6ca921f32acfc79ae0414c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "71592f252c83c00084c9ad6c315a5d16d8c99f0c8daf712481d0e42720a59add"
    sha256 cellar: :any,                 arm64_linux:       "066b5d7c38fef66bdebbd6b272e21745861fd4af6ef14fe91a7d212281686fba"
    sha256 cellar: :any,                 x86_64_linux:      "414922f5d3299429a4b3de80139ab6d205a0752a8a62aa1355b3ff8e1bb7d825"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
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