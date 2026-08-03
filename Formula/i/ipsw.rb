class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.707.tar.gz"
  sha256 "fefc06d9f2351689117ac3a7708d296d15626f5667d2c9a4e57533fc5f46527a"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4a86008f0b3448023cbe80e31e98dbcd0a8412e8c1d3a4a2dfa8fd7621187dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4020541b365eee85475a4a4767fc6153cdd9e551f9789593a3f2e8c30b4ceeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5110e2e23aa16a23012932a2338658fc4e4d50e2de56c24d1fa3b11b5eba585"
    sha256 cellar: :any_skip_relocation, sonoma:        "74f3c2a1983a75e7a4611c96caa67491fd9aeef37f1b81bd22704e92e908d0f3"
    sha256 cellar: :any,                 arm64_linux:   "09fe67c086eafde3113e8f0e1eb51adcddb58cb654fc60b91ab165fba34db083"
    sha256 cellar: :any,                 x86_64_linux:  "1ffc82f904c7949908c895de5f0e7593a5da12e2b71bb46e0e75efa4214d8f68"
  end

  depends_on "go" => :build

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