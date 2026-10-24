class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.48.2.tar.gz"
  sha256 "c003d5200f80e5ee5bc0f0d54640f51273f26cb7ee5a308025e6ba7ce35db834"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f40bab5a4708925273715d4e4900c3c0e608afa1726e0ecd671408eb4d5fd302"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a1061392e471ac8a54b3a13f11a02683e06ce0ca70948ecb43904ba6e7c9e64c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e5a4bb0ff42242024c84f8d3a54a9c0fb7f575c46a65d115a3fa807ab1d0d299"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fc873ad8eacd69e52b4c8519c47edd78c22ce4ee7441fe6ee5152696d10d5170"
    sha256 cellar: :any,                 x86_64_linux:      "738b5e2fafa96b7455e130bc488cb37f277f20b657c90449d0544f63a79d3273"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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