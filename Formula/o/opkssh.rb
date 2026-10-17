class Opkssh < Formula
  desc "Enables SSH to be used with OpenID Connect"
  homepage "https://eprint.iacr.org/2023/296"
  url "https://ghfast.top/https://github.com/openpubkey/opkssh/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "28d9658b09c138c69b0c4f6378518de5713227d1f9d3eded02cab75ca3ed3701"
  license "Apache-2.0"
  head "https://github.com/openpubkey/opkssh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cf0aae9a25526199f66e22981d672717691f4663a45f1ded89ca5d121f3fc8e6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cf0aae9a25526199f66e22981d672717691f4663a45f1ded89ca5d121f3fc8e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cf0aae9a25526199f66e22981d672717691f4663a45f1ded89ca5d121f3fc8e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1057a11323775efc19fbe5e31cc3ef7a6d9764a308bd4fb2f66bb13cadde2420"
    sha256 cellar: :any,                 x86_64_linux:      "0a0811c0de7f266489dc1a6320df7573b5d669a64b5ba73c14f2b9dbc2c89aff"
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