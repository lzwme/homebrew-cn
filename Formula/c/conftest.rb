class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://ghfast.top/https://github.com/open-policy-agent/conftest/archive/refs/tags/v0.63.0.tar.gz"
  sha256 "eb182a93a0d58533bbfc3d50e3c64bf825426c65511a45f3a8f8ef995cbff6ae"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06b90408a016d5e90a11f97f59890f4ecec26d9fe71ac1c299b33c4c14671b9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9775c12b8041da285ea8a497dba7b0d3373b74461b57bf14239f84a6e811c2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b34f54d3055277e9bc8cdd15bbf81bf1b6426a1e0e3073d88c7175d58a4cea56"
    sha256 cellar: :any_skip_relocation, sonoma:        "c28970942ab7e31e1bb5d4d7205454749058a87c437e388b072130c16d5af82f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75f65e553044f0b35df573c059af0ff4fa8594de28171064a79b85ae8427afb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff739d08b8a7fa4a052bd3296ac37c48221a3ca7237d525528ca996a268c8862"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/open-policy-agent/conftest/internal/commands.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"conftest", "completion")
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}/conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath/"test.rego").write("package main")
    system bin/"conftest", "verify", "-p", "test.rego"
  end
end