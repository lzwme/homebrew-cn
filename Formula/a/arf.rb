class Arf < Formula
  desc "Modern R console with syntax highlighting and fuzzy search"
  homepage "https://github.com/eitsupi/arf"
  url "https://ghfast.top/https://github.com/eitsupi/arf/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "3d72268d7390b5838a3cdf270bdda742f63269b592d292c1d6f814a3cb555d67"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bda878cc35314a34eeb35a59f5468ae56286de231f1d81844439ab39896e80e1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "640b6e962968a179b4f6a06bff264b5421cf6f7a8dcc3349aa403ccd1be07b0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1ace8e45f816b56052c71868aa4fffb1df8ea2192c51ce4337ead6024e30d5b6"
    sha256 cellar: :any,                 arm64_linux:       "c95e647f636fa91840999157dc63e2164e5ac7975632a73d354afec972f5e104"
    sha256 cellar: :any,                 x86_64_linux:      "02924acbdfaf187ab2b144e9dd8bc94c702e23101838b5a3cee3f6c637c5977c"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/arf-console")

    generate_completions_from_executable(bin/"arf", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/arf --version")

    system bin/"arf", "config", "init"
    if OS.mac?
      assert_path_exists testpath/"Library/Application Support/arf/arf.toml"
    else
      assert_path_exists testpath/".config/arf/arf.toml"
    end
    system bin/"arf", "config", "check"

    assert_match "history", shell_output("#{bin}/arf history schema")
    assert_match "sessions", shell_output("#{bin}/arf ipc list")
  end
end