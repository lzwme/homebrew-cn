class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://ghproxy.com/https://github.com/open-policy-agent/opa/archive/v0.53.0.tar.gz"
  sha256 "e7a34a82dd37f85f076d767e0ed5c116ebdbaa7a9f8cac54b0a74f6aedbb85fa"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "156bb10e7e21b362b6b485612eda08f76721cd5f7783fd4253d15e6c15bfa42b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "123d2738c95fa4378193f6b179d768987383af9115192b934bce9fc5d52050b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a7ade27f02702d55c009a7ea2041d52a55e3b2a22628e8f943cf32a131e2772"
    sha256 cellar: :any_skip_relocation, ventura:        "7928a25ef557d36c5670c132d52efa50ba1b4a8005477a05182ecae5a12419a7"
    sha256 cellar: :any_skip_relocation, monterey:       "1bb36ad8ea8e441b96e9723627607c53f200bfcbe87581183c4afd7a7be97811"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f1f8f3ce2b4d4185c00a543b775e2ab4faaf56603a79d374c36476bdf6543ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6d68d21be5db59d187da5d67a43787240ae8eb9da504bb9b85660f61f9c637c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end