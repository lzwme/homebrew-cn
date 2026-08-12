class ProtonPassCli < Formula
  desc "Command-line interface for Proton Pass"
  homepage "https://protonpass.github.io/pass-cli/"
  url "https://ghfast.top/https://github.com/protonpass/pass-cli/archive/refs/tags/2.3.0.tar.gz"
  sha256 "5814cef73741e31a7a21ef867a3c07e2bf245e993c9b75e7e0ae0041db14d787"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3161e675fdb8462653fdc1b55c77732e282b4025034016d2751cefbe87d43476"
    sha256 cellar: :any, arm64_sequoia: "94d44745e6a06a5c6db740410f936ce3dd57895df757def026f2cc2b19f157f5"
    sha256 cellar: :any, arm64_sonoma:  "a48e38dae8801eb7a6eedb970334650dc3819e9e9f1920df1f72f02798347a68"
    sha256 cellar: :any, sonoma:        "3b9c6fd521d5d709805dd436be1baf513caaaadf7dbfbe48a0155e50a1f8194e"
    sha256 cellar: :any, arm64_linux:   "72daac13e3b00306d7160da754bb1d74641fffc9647d8b758f7f3343b7a9d829"
    sha256 cellar: :any, x86_64_linux:  "c8bf8890cc395297f0a9c45b49036ac89a541b3a4db7720ce2c75b1001e52d9c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  def install
    system "cargo", "install", *std_cargo_args(path: "pass-cli")
    generate_completions_from_executable(bin/"pass-cli", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pass-cli --version")
    assert_match "Successful", shell_output("#{bin}/pass-cli logout --force")

    # Most operations require an authenticated session or keyring access.
    ENV["PROTON_PASS_KEY_PROVIDER"] = "fs"
    output_log = testpath/"output.log"
    pid = spawn bin/"pass-cli", "login", [:out, :err] => output_log.to_s
    sleep 5
    assert_match "Waiting for authentication to complete", output_log.read
  ensure
    if pid
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end