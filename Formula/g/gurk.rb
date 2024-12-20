class Gurk < Formula
  desc "Signal Messenger client for terminal"
  homepage "https:github.comboxdotgurk-rs"
  url "https:github.comboxdotgurk-rsarchiverefstagsv0.5.2.tar.gz"
  sha256 "a8c190e081d9905ea6e71d38d56cb8f19596999a20cb9584a552ce46e6f88bed"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "14bf53140261f7ed7f24204a45488d976f886af6bd499d9db6a0c5033d771324"
    sha256 cellar: :any,                 arm64_sonoma:  "eb22381b125dd6659cbb3d8c8199f8c9e9afc47579cf2217e66c6a262574da07"
    sha256 cellar: :any,                 arm64_ventura: "94516c323b741c91a611482bb605d4ae5d077d45df17384288b93385a7222987"
    sha256 cellar: :any,                 sonoma:        "e4fe3a1dccb3b5a63692eaf9fc5744bf066f0b1d6b6485454b70f9f9ef5a5bf0"
    sha256 cellar: :any,                 ventura:       "106acb5bc5b7907423e35e972e5092d3ed33895f665af65142c4472540211e60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20984e9ec868ddc8e386370304e60dc5c85c4a8e4c25e02dcf24dabadc700427"
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