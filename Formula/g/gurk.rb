class Gurk < Formula
  desc "Signal Messenger client for terminal"
  homepage "https:github.comboxdotgurk-rs"
  url "https:github.comboxdotgurk-rsarchiverefstagsv0.6.0.tar.gz"
  sha256 "63302a65e4f832797911651f688e1f056f049da99b8d396d114f002629d03f2d"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f8d19b14dff9ddd409fb4f3c1c0a720adb5ec1dea60e9797b397526794426731"
    sha256 cellar: :any,                 arm64_sonoma:  "511b16ab9295ab6563a9b15bb0c9702c16db3546f2d524b07f24851f170f5f61"
    sha256 cellar: :any,                 arm64_ventura: "18958dce9e357e392681000968b4efbe53321595d68e742b260751022323043f"
    sha256 cellar: :any,                 sonoma:        "3c1ad552be8188c97c9428fa8bab282d9e790d9a780d3b0d6257a9dd77bd0da3"
    sha256 cellar: :any,                 ventura:       "4950277bdfc6b6652ddefe480edcf4246bde9695ae12fdf04f903da805c57f07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a6feac30ce966b6afca24b6adc3e287678c193e521e24a3fa9fd1e300ca3bf4"
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