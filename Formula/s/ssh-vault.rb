class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://ghproxy.com/https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.0.1.tar.gz"
  sha256 "38bc41c88b540d694591d1c2d911ff799c22ab7b4ffabc5058f05e3830f472f1"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b464b0b2437888088eb4b4ee5df126a7c7d7441220d8668d4a4dc1047f36cb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0088467c63f7dad44f3ef52c6b65c6f84063eb2635a035564bb3ea7041606e1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f67e5a6811a027dd21d8ddcecb634829ba4caa9638624b4388223cb076db011"
    sha256 cellar: :any_skip_relocation, sonoma:         "02124b0120c0dd2de37f60b2d6061365e9bbbcd1f8e317f24dc4a87212d28a0b"
    sha256 cellar: :any_skip_relocation, ventura:        "73a0be0cac446d704b095af7011f181aa18d92c587c41c6276cf9fadc99e1840"
    sha256 cellar: :any_skip_relocation, monterey:       "ba51709863c0f0760a7ca351e230c1b0b4f68d4202a6aaa731979b81c9c8519e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88ea0f8e4729d8ca4b2ea3099a09a19370c6f912eb1720d96ffab91c438789e2"
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