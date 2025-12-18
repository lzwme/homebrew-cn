class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://ghfast.top/https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.2.0.tar.gz"
  sha256 "293db51df95c2641540f7efb9d5d5e12fabcc70034fe9ad510bf9b158924f001"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6d514106841e69ca762cc916c00092434958e8ab5f23800724ca39415ae7dd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dbe22f1285e18065d68835963593481a9aaa5ae0dddaca25b70a08b1736c972"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dd45b4ef84388a8707faff74c0a454c45582af69ea0c6937b87b26580e36d66"
    sha256 cellar: :any_skip_relocation, sonoma:        "529b80b0d4ae45d38263b67888b1a0477030f837f240757baa681f5ef2da79df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b84a9ff5dc202d75df391ed70b6924c0f67958a35097ea24b8472e1e0373f71d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b9f5973065b7fc1d287d34efc79efbf0ce38226b7dc9874dcd54110c43047f8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINixf2m2nj8TDeazbWuemUY8ZHNg7znA7hVPN8TJLr2W"
    (testpath/"public_key").write test_key
    cmd = "#{bin}/ssh-vault f -k  #{testpath}/public_key"
    assert_match "SHA256:hgIL5fEHz5zuOWY1CDlUuotdaUl4MvYG7vAgE4q4TzM", shell_output(cmd)
  end
end