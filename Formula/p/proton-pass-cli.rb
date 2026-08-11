class ProtonPassCli < Formula
  desc "Command-line interface for Proton Pass"
  homepage "https://protonpass.github.io/pass-cli/"
  url "https://ghfast.top/https://github.com/protonpass/pass-cli/archive/refs/tags/2.2.6.tar.gz"
  sha256 "a55c25967535dced42bbfe84f92594bcc541613f2e9a4442cfc80549aa18d0b4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0b0c9743fbd990ca8f76f78491c1f9ae803de952c3f0f37520605e369c65c8b5"
    sha256 cellar: :any, arm64_sequoia: "48ef361ff88cbb58ee3292be3926bf1dfbd3c21be5943be4f8287fef23d679d0"
    sha256 cellar: :any, arm64_sonoma:  "2d812a23f5cd9c30dd465fca87e2ab45f1bf09edef999b240a2e22e63d716d9f"
    sha256 cellar: :any, sonoma:        "3802862c6298e78c4a54eb2d23f3003f94bd5a684f1c427a02ec03a7a3cce30e"
    sha256 cellar: :any, arm64_linux:   "11d59404188edb6f7fd5f5c1d4db6dd0a19e14beaa305b0a22b5db78cae008c2"
    sha256 cellar: :any, x86_64_linux:  "76625f65c85f352ad0ff172e51315b43e17af36132b400b9b518bd36609f3060"
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