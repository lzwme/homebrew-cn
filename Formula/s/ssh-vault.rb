class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://ghfast.top/https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.3.6.tar.gz"
  sha256 "5b948701b0ebe4ac72e12d898e7ce800eebd7ceca9a7748f73f3e680f3d95461"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d0abd65d6f43511d7a78f6eea107d062639590361a12329289efd1e0336405c2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1e0223cc24d67d1ece25e3eb8e804b242f4ff9b8d3a90d9b485888bb7f9344ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8e296dd77befd5f5f7a2985ebc1c8fa3529967c522325cb58f3f54d36300298e"
    sha256 cellar: :any,                 arm64_linux:       "6af9c127b430f753a041368fb1fb97cb31b56cddb192d11336e108207fbf1715"
    sha256 cellar: :any,                 x86_64_linux:      "38c7023db8494ae3309e34b4c539995e82c1685a6566f5c79eb04d934e99872b"
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