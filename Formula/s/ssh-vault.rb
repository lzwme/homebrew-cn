class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://ghproxy.com/https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.0.3.tar.gz"
  sha256 "50d9eac5174aeea0fd415a3d792c8b4c33044240ffe4f625287641877ece816a"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f837dfe4db5dc472b06ba05a242fa8aae86cbc07cb7eab2cbf3385f0d7295c6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fa67376dce6c8122174186909459ae6d36269c7f3ae8992f6852e0009341c73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8aeb34e43d9991574eb7ad0e865c18b2f10e560e1e6738a7a056cd81705856e"
    sha256 cellar: :any_skip_relocation, sonoma:         "68da6f068108e8737ae263537dbe62e95e4ef3837f0f49a6281da8ac3f3defaa"
    sha256 cellar: :any_skip_relocation, ventura:        "c0364f61ac33ce5e967463e8866da6cd1c4a592bf75447528942016364378089"
    sha256 cellar: :any_skip_relocation, monterey:       "fec4aedf24a0270f277ee739f3ca54b11fdde3a773e6be1ce675778a3d902338"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e659950bf6f8e7753c1aac33dba5a64cae679eb586ce5fe08688611a2264641c"
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