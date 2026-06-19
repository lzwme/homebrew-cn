class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.695.tar.gz"
  sha256 "bbc8294818e0adb0a132395f476c759a67731af2f3763d51462980c188f2424a"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8394409983c479aaa423fbeb13a5c550670dca733509ef83df45f388866cd10a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7078b1169a9493b1dcc3714c0e50b3cece35ed01294960309e3f3482980af4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eda64197832c4ee16cd67d8f8a77d4303e6772d9f4174d2bfbcc73758459425b"
    sha256 cellar: :any_skip_relocation, sonoma:        "687a51e2322c2dce307462be1caa86d8f5d9815ae19a5b58195bc53f46a876cb"
    sha256 cellar: :any,                 arm64_linux:   "b57f5a2da32860392f02c9169048f3df9fee6ed6d0cb6cd6ebd9ba03fee21d68"
    sha256 cellar: :any,                 x86_64_linux:  "a873e0ffe2c9b96a1a7b9ea31920a3cb37b3742f8213359b7fa491bdc37b4560"
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