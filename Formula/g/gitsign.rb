class Gitsign < Formula
  desc "Keyless Git signing using Sigstore"
  homepage "https://github.com/sigstore/gitsign"
  url "https://ghfast.top/https://github.com/sigstore/gitsign/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "aad96074b912925ed2169730870ced36f705591ecdfe7d338aca6ff6a97f243f"
  license "Apache-2.0"
  head "https://github.com/sigstore/gitsign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f6fde2a707894aaddb26eeacdb083312987dcab04d0aa6279e5ed7373e6a29c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f6fde2a707894aaddb26eeacdb083312987dcab04d0aa6279e5ed7373e6a29c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f6fde2a707894aaddb26eeacdb083312987dcab04d0aa6279e5ed7373e6a29c"
    sha256 cellar: :any_skip_relocation, sonoma:        "68f9acb066fb84377f5a85e18268abb3286f8d53bdc9f60f4408ad81a46125e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91ee0f100c534299ba44977a99db4d589a5b32337dfed28d3b8cc04b0b9e6ec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "613f83a2ba93e749b57cce00386233ceacd1ad93143f1d583fbabc7f6708c8b0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/sigstore/gitsign/pkg/version.gitVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system "go", "build", *std_go_args(ldflags:, output: bin/"gitsign-credential-cache"),
      "./cmd/gitsign-credential-cache"

    generate_completions_from_executable(bin/"gitsign", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitsign --version")

    system "git", "clone", "https://github.com/sigstore/gitsign.git"
    cd testpath/"gitsign" do
      require "pty"
      stdout, _stdin, _pid = PTY.spawn("#{bin}/gitsign attest")
      assert_match "Generating ephemeral keys...", stdout.readline
    end
  end
end