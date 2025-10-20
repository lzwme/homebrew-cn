class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://ghfast.top/https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.1.3.tar.gz"
  sha256 "84ddf474cac5e0befc7bd9766352a5e24b817160eee29fcd99e5b54ec270ead3"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e01e4aae13328801ace2354ca4ed1eef9a08bdad919d2fd37d549808e335d21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c74326e7945b8357416f4a029603d904a218a74dd5e3718d3b594c2a372726c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "701002f736ae175471d99f1f4db419f3f01603059eea61c06f13cec19b9b1b3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1696b64659d268f72187da4712ee1ec3264805589eec9ee05770f58f65e43f84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8607490c051e2dfa98037e6384c29da2be820593215f729636e2fa6bf66a9b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed8d674a160aa518bd6ccaf0a002a6cac710fa16079547674f8c5f293655c0ae"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "utils/linkage"

    test_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINixf2m2nj8TDeazbWuemUY8ZHNg7znA7hVPN8TJLr2W"
    (testpath/"public_key").write test_key
    cmd = "#{bin}/ssh-vault f -k  #{testpath}/public_key"
    assert_match "SHA256:hgIL5fEHz5zuOWY1CDlUuotdaUl4MvYG7vAgE4q4TzM", shell_output(cmd)

    if OS.linux?
      [
        Formula["openssl@3"].opt_lib/shared_library("libssl"),
        Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      ].each do |library|
        assert Utils.binary_linked_to_library?(bin/"ssh-vault", library),
              "No linkage with #{library.basename}! Cargo is likely using a vendored version."
      end
    end
  end
end