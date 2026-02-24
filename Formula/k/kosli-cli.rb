class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.44.tar.gz"
  sha256 "3a4a0e0347e30e3673b792c04139c790f277941e46c76aa4a6148c2ffed31386"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ffc5e5c8061926d48389fad6e4c26cfb93609fce574c1780c6f4b92da587b1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1a56fd805242f3637a5e8376a9f2049100899754ea874e0a4bc877f6b808725"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04cc058aa0dc6a5cd3811ff6c0eff4d1baeb14f3e993d3af863b7f1fa87f6b5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f718aa8a2d5792b78321f54e30739b4a8862ad15a500e0c908911b3c7bbcde9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b364d06517517da505e4bf8089d517d77d34c0f7c7693566c34bcce45798453"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c8e060cf518b5a88dd9c545cc0bafd7693e8e55ab800b8939dfdf758368ddd9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end