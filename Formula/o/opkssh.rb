class Opkssh < Formula
  desc "Enables SSH to be used with OpenID Connect"
  homepage "https://eprint.iacr.org/2023/296"
  url "https://ghfast.top/https://github.com/openpubkey/opkssh/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "b38b6ca60cb97fe9064dfc6aa6fe1969e76d54e0d996114824b5633d6285ee18"
  license "Apache-2.0"
  head "https://github.com/openpubkey/opkssh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1ecfa452b39a07d70d9f054388968fd387cd9e9a3d877d86281c7d23ff914eb4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1ecfa452b39a07d70d9f054388968fd387cd9e9a3d877d86281c7d23ff914eb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1ecfa452b39a07d70d9f054388968fd387cd9e9a3d877d86281c7d23ff914eb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ce981b6407be83a71e64d7f4c7cfe66831a9a8c9dc2230482ef87a7fe92659d7"
    sha256 cellar: :any,                 x86_64_linux:      "f37181c8e3464e0a7d052a6e37ea0fc24309a1847f611eca14c7e91199d8e0c1"
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