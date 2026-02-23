class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  url "https://ghfast.top/https://github.com/eycorsican/leaf/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "3555b38385f38d81e88bcdaee13c9066f6bba526fdf31499210c0b1eeb0b3b31"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3579d48166dabde991b1a2140dbe1e0f28f0fad4b1f1f9c3fb90044621c5ef2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f291ee094125dca23c46e762aca2713d6a1f6e3ca00d43d9d5f0309a43e2b1a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d899c468ac5fab42856ffa2f4add6a654e27c0d19b74e31360d745beb30deb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5295d8003fe12378677c3e012cea2a3cfd6f64461a3df7c56dbaf7ef24c17fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f1fd8d86fcf4eb1fb6620998f496ee4e0a17a76b72acc106eb4ee8a903e3b8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68dbc2d6a5c20ce7186d73a3e86945b7081dd6a846f7a8f736a8a30566f2b96f"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install a `leaf` binary"

  def install
    system "cargo", "install", *std_cargo_args(path: "leaf-cli")
  end

  test do
    (testpath/"config.conf").write <<~EOS
      [General]
      dns-server = 8.8.8.8

      [Proxy]
      SS = ss, 127.0.0.1, #{free_port}, encrypt-method=chacha20-ietf-poly1305, password=123456
    EOS
    output = shell_output "#{bin}/leaf -c #{testpath}/config.conf -t SS"

    assert_match "TCP failed: all attempts failed", output
  end
end