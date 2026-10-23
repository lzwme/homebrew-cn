class Opkssh < Formula
  desc "Enables SSH to be used with OpenID Connect"
  homepage "https://eprint.iacr.org/2023/296"
  url "https://ghfast.top/https://github.com/openpubkey/opkssh/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "87d96ceb1658d90d748e63bb18c6432f57e57f0f2f12791fccbe70f4af1fe86f"
  license "Apache-2.0"
  head "https://github.com/openpubkey/opkssh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8b252065f216d7d72a80137fd1cd51ab2a8afe25856abf9eb0c618ef5fc5a6d3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8b252065f216d7d72a80137fd1cd51ab2a8afe25856abf9eb0c618ef5fc5a6d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8b252065f216d7d72a80137fd1cd51ab2a8afe25856abf9eb0c618ef5fc5a6d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7783414ee8a15849b21e04dff67928292efb49f2f69eecc465257c1fff366a7b"
    sha256 cellar: :any,                 x86_64_linux:      "92b2f02aea556a2c83d6dde5b49c24a0680615d5ec70d5fe02d88bf2058f78b7"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opkssh --version")

    output = shell_output("#{bin}/opkssh add brew brew brew 2>&1", 1)
    assert_match "Failed to add to policy", output
  end
end