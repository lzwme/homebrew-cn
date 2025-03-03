class Gurk < Formula
  desc "Signal Messenger client for terminal"
  homepage "https:github.comboxdotgurk-rs"
  url "https:github.comboxdotgurk-rsarchiverefstagsv0.6.3.tar.gz"
  sha256 "b3d2a3c87e7cb4ceaad42ed329423abd03ef54fb0ca5502f815de0f81c86368b"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d37761fa3cd22bd63ca63c1b5eb09e7ee674d7ef135f859753c47fab6cbc684c"
    sha256 cellar: :any,                 arm64_sonoma:  "2dfe640a2cf3f4b4b0b505fc875be364d01bd9a1b666f9d0f3db4028f009a0f6"
    sha256 cellar: :any,                 arm64_ventura: "abc5dcabec944112aec1b323612b4f00cab9d25b20aff7b2f9c4898d69d90b9e"
    sha256 cellar: :any,                 sonoma:        "fbc0f0178fed933b72871bcc1ff842ea45ed636d0beaecb6564f0087e7cb6d26"
    sha256 cellar: :any,                 ventura:       "43c4bc23d13c40e4b6b2855735d28ebccf648ab715b93cb926ca5bfa99453f9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7e157ab0d880b840a15ab2f1b1c83956cb2796f6db2482acbaa76177dc53ba8"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gurk --version")

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath"output.log"
      pid = spawn bin"gurk", "--relink", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "Linking new device with device name", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end