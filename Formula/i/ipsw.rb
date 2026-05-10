class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.678.tar.gz"
  sha256 "0a7e5c5afa6d7c64acd50f3242be53ee8179b5e013c0717c448251e1c933ba9d"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62496c4d2c63b1264750a567730087ca22a443fa2d205bdb907af2452c1f8443"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77075523521d8015b3aba14bb8229f6f3cbe3a669c51baf812e9590bae4814ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a6bdb2cb698415a20b2b72d5031bf09a4f7a167d79f9c7d66d0f46e88dbc892"
    sha256 cellar: :any_skip_relocation, sonoma:        "48bc18fa529560f5a1c4f243ea84600695a8b9521e4c3f6de1b60632b395ec43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1be7c0adcb28bf2273e75939ba96d57d8c2b20f62ec1e2c398b9232aec8d5cb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e66ad800b417a290dd9b6f33c6ea0ff50f78c126722ee03412b7dc7136515ef"
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