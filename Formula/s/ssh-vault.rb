class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://ghproxy.com/https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.0.5.tar.gz"
  sha256 "d1b68bfe54eb48f35302e4793037475546b3b320676e6178064d2c966dcfece1"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "62ab051370bf7febef339dd31a588115ff39d63908278622d3e7808777e4bc35"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7249d1c67a24719c25951f76c42a6dd33c71587ad1a4c4a7182d96c0f333e848"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99d1e536f2d786736bdbdbf9b4b98bac75dbd3ab74145a3aaf9ab82879be431e"
    sha256 cellar: :any_skip_relocation, sonoma:         "7427edaabb0eeca139226ad26d7a6f7d514954f3cbe4bbd4c179084630fa4b55"
    sha256 cellar: :any_skip_relocation, ventura:        "26bc2e0f64631fc69a25c2623497b76126ba89013042cc7afdabf818a827cf7d"
    sha256 cellar: :any_skip_relocation, monterey:       "1f10ba36cbd64f39848ce39706ed4b75658d2d6d49bfa605d9916d0a88089884"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "163cca04f7f4b42b329c8dc2642564cd13f12123e152869c2a103d3c498c459c"
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