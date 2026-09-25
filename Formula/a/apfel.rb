class Apfel < Formula
  desc "Apple Intelligence from the command-line, with OpenAi-compatible API server"
  homepage "https://apfel.franzai.com"
  url "https://ghfast.top/https://github.com/Arthur-Ficial/apfel/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "baae1ab8e1a7121e3a998e36090343e1dbdde283639fe84f5a625f8bae25038c"
  license "MIT"
  head "https://github.com/Arthur-Ficial/apfel.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9bc8244e3b0307c01135b59d2c2bd267c402587cd21933896f26e914c8b0723d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0145710b5129b263d4bb7308ea941501ee50bb75afb73f72ba5fe97e677b0270"
  end

  depends_on xcode: ["26.4", :build]
  depends_on arch: :arm64
  depends_on macos: :tahoe

  deny_network_access!

  def fetch
    # SwiftPM tries to apply its own sandbox, which cannot nest inside the
    # build sandbox; Homebrew's sandbox still confines the whole process.
    system "swift", "package", "resolve", "--disable-sandbox"
  end

  def install
    system "swift", "build", *std_swift_args
    bin.install ".build/release/apfel"
  end

  service do
    run [opt_bin/"apfel", "--serve"]
    keep_alive true
    working_dir var
    log_path var/"log/apfel.log"
    error_log_path var/"log/apfel.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/apfel --version")
    shell_output("#{bin}/apfel --no-color --model-info")
  end
end