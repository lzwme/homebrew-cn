class Gurk < Formula
  desc "Signal Messenger client for terminal"
  homepage "https:github.comboxdotgurk-rs"
  url "https:github.comboxdotgurk-rsarchiverefstagsv0.6.2.tar.gz"
  sha256 "515b14272b21d83a040310e1aee008b64c6f549215fc2a819a2e87bd8fa1fec3"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bc799e32ce54e898f19af4f63173c7681ba4d30ebc870d4d3705f3fbc3705bc5"
    sha256 cellar: :any,                 arm64_sonoma:  "bc2bf1c05fa53ac73322bb90f450dfa1fc390665d6ff5d665b4452f7c33bda98"
    sha256 cellar: :any,                 arm64_ventura: "a8cc0339b3774d2297b0e918923ed0829ad8a1501d125b6371158816a4f1d1af"
    sha256 cellar: :any,                 sonoma:        "4091e8b495d49a3c448280a869263f94edb8e5181c8450dc1ac36de0b77d8b31"
    sha256 cellar: :any,                 ventura:       "33d76c063f21b281f5ba8475e395ea3d2936765b863a074910011dd239c96264"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c8e108bd4ffa28b00f219162d1e513f85424d702828afd168c27ef8f7555a13"
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