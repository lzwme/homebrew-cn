class Gurk < Formula
  desc "Signal Messenger client for terminal"
  homepage "https:github.comboxdotgurk-rs"
  url "https:github.comboxdotgurk-rsarchiverefstagsv0.6.4.tar.gz"
  sha256 "6e1ea43aad916e5c7f1fbbb852b06b28d9a5546d1bf80d93a50c3d6d9d3c42a4"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2d662402b6bc9599e64e798c08694cfd9e1500baadfb2021b67c0b7a251a0660"
    sha256 cellar: :any,                 arm64_sonoma:  "19e81b481169949f427200a84199f9a43bb0ba697c5d1849e55a62192fe6860b"
    sha256 cellar: :any,                 arm64_ventura: "efb878f8b9ae2e7c3d5a46b8b4859762a2ba7393ac80a5302dd16553c0df6fe6"
    sha256 cellar: :any,                 sonoma:        "e2480251a4ff3678b6192daac409a07446ed881e243e76b89722f9bc37ba9a43"
    sha256 cellar: :any,                 ventura:       "649d980b5309cefa205d569ee8495423f3ab3131c931cfcc4f85b9d4e61aa344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46253e8c881a99548b384fef25a64591bcb61d06fb65c0a2601e2e43dbe86467"
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