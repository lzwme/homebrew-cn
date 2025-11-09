class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://ghfast.top/https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.1.4.tar.gz"
  sha256 "abd4f3154654b7c65606bd6212ad27297619e54abe8431098d3c24cb92c9215f"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b42eb1ead32eb7e21e57faa267385544f2f375706fb913cbc785b0ca71a2446"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0671fdb44f5c4657e98ac92811f7eb7722e7250c03c231d3a03cfd781e6e290"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d2c1b6ba072c5c607aa9af60386185bc5a5cdd832ae44920017930e5b1ce828"
    sha256 cellar: :any_skip_relocation, sonoma:        "852e7fa058f17cf5cd136c0b4ef13abcc949fbe6c76a664418b7c8a93ed95753"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95e66f499b5411e6485d465a0da6ad491bcd85afe942864b06b823a42de4f8f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcce5a4a5243f86b111f9cbd76dff2007ac4ca5aaad06c69117c47ee1edb9515"
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