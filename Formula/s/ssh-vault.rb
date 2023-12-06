class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://ghproxy.com/https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.0.9.tar.gz"
  sha256 "af12485c030ee233227a75ffd13b86054d0e62d7b7ccd540308d75ad665bfb9f"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b8ce3051e534a2aa01dc6da21cbf162a03818ff5941d602525e198080253103"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a35c3100fee15fcbf9aeec01dc5cdbb0cf0ea0c4b3bec853a713bc83f7ebfeb1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f84b6a0cfa583d9c8e9bce1a54f659442b0ee08d239115617fda77a6776407b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab1b07ed061c42e3c767e36373d5e000ce2dfd21f8532a7579a789f6f4ca5ad8"
    sha256 cellar: :any_skip_relocation, ventura:        "af08cf8193c9db221a91802ce752302d701829772eb54d147b25c958afc639bf"
    sha256 cellar: :any_skip_relocation, monterey:       "a6d094542f0c5911b1429caf4d5407d0d4f9f6e6be8fb072c1dbb079167a4471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ce345ddab33dbd69051018ec78fd8843845b26a41579a000c085396b2e28c6c"
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