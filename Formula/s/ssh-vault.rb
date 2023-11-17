class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://ghproxy.com/https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.0.4.tar.gz"
  sha256 "28d4648f41ede587df4aebb80d9857292e7fde2e732f03515e5794d10e0bf1af"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ef6bdc2af00c3e5176cd67cc0c39b9a7ba228e66c7e070030973addf8e1f266"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e313d6a127b157f84caf535e83a3c7857bac25bf4da6034345f92169c13a0f0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3606f2e7a8c931cec5ee36485d51a12e12be8206c6067032dafd7139512bb69"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a4d260ab6737a57594d244caaa2a7c218b7f9e44f8369abbd1170deb36631da"
    sha256 cellar: :any_skip_relocation, ventura:        "9b6eba20ab738b0fbdfb2d5727ebfad247da00c6755a9ddf18e9d50ee7a1912c"
    sha256 cellar: :any_skip_relocation, monterey:       "28041361dc57c352644e4ff28409b2ae1e0a479866d02ecdbe6db07a4c7235f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1994af5e851e293a3b5b8c979e980a5ec66cc4c2252cb79e62a9502e9886417"
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