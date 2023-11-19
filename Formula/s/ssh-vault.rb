class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://ghproxy.com/https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.0.6.tar.gz"
  sha256 "8ea352a6c39e1c6854537fc441eb0bfec5ffb06643c1b254f1aef4ec4c389586"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b041a70fd2e311e7b7d105b1b548c181732a49e6c75fcf459c5d55a888e4ef0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b5f0b8500962a514fcf73f3dc98e7ee5897223e099a14ac4ccfc6407a063275"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9de509afd5b9f122229f4c7b3f5996f410fe41694c6ca47eebac46b91f40b176"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6853eba7ee198a1d1b31a9f9a93adddd8324286a54d219af51694b12ba9eacd"
    sha256 cellar: :any_skip_relocation, ventura:        "6c8738c27222db9209db21cbf10a78676a10d420ec52917dee9f4ff4c384086d"
    sha256 cellar: :any_skip_relocation, monterey:       "1847fdc33ad0cf3922720177d53b180ead87dedd89e74cb552abf4d40eefd3dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64ccd7390db0b3b66a952664696a8dcbbbaad8e2cda716a757876ed3210e2f58"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    test_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINixf2m2nj8TDeazbWuemUY8ZHNg7znA7hVPN8TJLr2W"
    (testpath/"public_key").write test_key
    cmd = "#{bin}/ssh-vault f -k  #{testpath}/public_key"
    assert_match "SHA256:hgIL5fEHz5zuOWY1CDlUuotdaUl4MvYG7vAgE4q4TzM", shell_output(cmd)

    if OS.linux?
      [
        Formula["openssl@3"].opt_lib/shared_library("libssl"),
        Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      ].each do |library|
        assert check_binary_linkage(bin/"ssh-vault", library),
              "No linkage with #{library.basename}! Cargo is likely using a vendored version."
      end
    end
  end
end