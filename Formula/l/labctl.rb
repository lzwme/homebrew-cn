class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://ghfast.top/https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.77.tar.gz"
  sha256 "014baf9f0b1fa42402258bc4cdef6007ed7ec0ccb51d53336363d09036b38a5e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85f1296859a4babf9a1167f776c6a86209104e93d5cd0499880041e1f7854b12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85f1296859a4babf9a1167f776c6a86209104e93d5cd0499880041e1f7854b12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85f1296859a4babf9a1167f776c6a86209104e93d5cd0499880041e1f7854b12"
    sha256 cellar: :any_skip_relocation, sonoma:        "0eaa5b4bde2498fea8ce42a5226e530b689f20c2a174eb14c832cef6a7f33da5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f791c77647ce5c8b6d4d9d4f4e060c59330c692eaac007a20407a913d41206a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5252e90af6f83f591f57366a2689878113c8c0164cb29a979856f07a674dc1e2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end