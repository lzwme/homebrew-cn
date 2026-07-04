class ProtonPassCli < Formula
  desc "Command-line interface for Proton Pass"
  homepage "https://protonpass.github.io/pass-cli/"
  url "https://ghfast.top/https://github.com/protonpass/pass-cli/archive/refs/tags/2.2.2.tar.gz"
  sha256 "862ed0f6b9a50d3c0a4865ddba2a2bfc451854a5597c0ce477479f0d203286ce"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7660fdf2d176f58c0e9388076e75ceae9532890e1e8f65372d3200a113c3c79d"
    sha256 cellar: :any, arm64_sequoia: "e76732a9c9e4ecef7d240f231f962b05bb32ec402497047d67eefed1ac0f84fa"
    sha256 cellar: :any, arm64_sonoma:  "0444530ef94afda17f45d08368e8a77195e98b716c2602e3f64ace362c38331a"
    sha256 cellar: :any, sonoma:        "8d3475e2bdbd93182aa59178b56849921d2e99ba69a23a96e8e7862bd4f32cb3"
    sha256 cellar: :any, arm64_linux:   "9a1990879f3cf5ab3b22ed87b191553a6f2289a43ac422b28809271f8133fa27"
    sha256 cellar: :any, x86_64_linux:  "7a1e451e8b1e3809ba702cf383156e7a22f586aecff68ddfc12a3dbf081ce552"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args(path: "pass-cli")
    generate_completions_from_executable(bin/"pass-cli", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pass-cli --version")
    assert_match "Successful", shell_output("#{bin}/pass-cli logout --force")

    # Most operations require an authenticated session or keyring access.
    assert_match "Error", shell_output("#{bin}/pass-cli login 2>&1", 1)
  end
end