class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.649.tar.gz"
  sha256 "6aa8422507b4c212339e0afbe6823b99c81cf001bd4e0a16ca76edc9c952e7b1"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90696e2e9079b71044f322f9e4f04449bd8de30fdbb78d33ab1fe68ea9a9104f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af8fe929aa90d0295c75d3b38d6bc5e98f8bcb6bb6877692d44f88ba0e4842d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f2a5c91ce8c7203a11269efd3659713a5534cb8f0d246a6e47ef6e4ab8b3328"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ffc6beeabc17af0420f2847ddb961fee498087ddee6ff6f218c4f69515027ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdd844b3c6915339faab4f23df2aa6d61a4a5889da6b68257f5c9d7c3ee7ff3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40df48dc9602ff292a0848519b1a725e05467e554cb59c6f6e64a8cc3e465483"
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