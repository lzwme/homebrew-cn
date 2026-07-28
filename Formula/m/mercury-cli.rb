class MercuryCli < Formula
  desc "CLI interface for Mercury banking"
  homepage "https://github.com/MercuryTechnologies/mercury-cli"
  url "https://ghfast.top/https://github.com/MercuryTechnologies/mercury-cli/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "fb979f3f5b1843a8a86af1d4c1fc619e9b17c5bc2d5d28b5ec17edc166f33fd9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e8d3b4cd26a37913bcb4a1bd2a54010ba735fef8b5907a8637820f3b51febe9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e8d3b4cd26a37913bcb4a1bd2a54010ba735fef8b5907a8637820f3b51febe9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e8d3b4cd26a37913bcb4a1bd2a54010ba735fef8b5907a8637820f3b51febe9"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a5b87676f9dc581c53af6516af99c0baf8a3e5b398274f25ef9801760e2dded"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36b312f1aabbb48a0be59b66fb61714234dd2bfb87a14a20bce7e11653ffa9a5"
    sha256 cellar: :any,                 x86_64_linux:  "70f7cb2cf7c7fb280c193b8123344db21097c9281094e1616c5943a5e4c94ae3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"mercury"), "./cmd/mercury"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mercury --version")
    assert_match "Authentication Status", shell_output("#{bin}/mercury status 2>&1")
    assert_match "Your dedication to modern banking has not gone unnoticed", pipe_output("#{bin}/mercury hat 2>&1")
  end
end