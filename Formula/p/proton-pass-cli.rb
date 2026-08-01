class ProtonPassCli < Formula
  desc "Command-line interface for Proton Pass"
  homepage "https://protonpass.github.io/pass-cli/"
  url "https://ghfast.top/https://github.com/protonpass/pass-cli/archive/refs/tags/2.2.4.tar.gz"
  sha256 "088ffbbc1ef244847a40c9e547517ed80b26c47a0095e3f076c1387dedf43a68"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cd221a4e04bc9ec33594c7a5719d3fc847cb35419d4cebfc4ed1f770c1259402"
    sha256 cellar: :any, arm64_sequoia: "8dc7690f929cbfbc01a71a0b087f677852fb8c8efb1876a0e9c91e91f5b54775"
    sha256 cellar: :any, arm64_sonoma:  "6d70a7d46edbdf34c839ce02553ce27e775b4e0cc0880ba7498f800690a332de"
    sha256 cellar: :any, sonoma:        "c808e961f4d80d2fea841c5df33d077ad89db61002e21baaa345236dd931fb83"
    sha256 cellar: :any, arm64_linux:   "90582a1db58a172218a45cdcb98dd57c9be1fa72afbf4d3fd0ca229d536bfcac"
    sha256 cellar: :any, x86_64_linux:  "06f0653abacf06486ed433058594be70ebe6468f1100c863e5b2d98415040190"
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