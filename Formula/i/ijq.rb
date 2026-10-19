class Ijq < Formula
  desc "Interactive jq"
  homepage "https://codeberg.org/gpanders/ijq"
  url "https://codeberg.org/gpanders/ijq/archive/v1.4.1.tar.gz"
  sha256 "5a4397999a6dd7f3c31e6f907de7137ee9a1fa24e7a425718ce50f035b262036"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/gpanders/ijq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "718a953482cc92269a6d2de9959248b96e4524b1270ecbb00b8a79b634a1a289"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f5e79b77282979f791c5348745b92f8295c818fbab9525b17f6df0ed30ff59f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "295676b10bd1564e13a09d8d59f6029207944adbdb3b940fdf2c47214fa4a9fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a3f6f849e4100d19392308b6824b032f6784677220d0e93897523c692660f4ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7c819542c75d1bf62815fa87abeecf6e838240ee3e1ae5a1586dc8168cd2ff53"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  uses_from_macos "jq", since: :sequoia

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ijq -V")

    ENV["TERM"] = "xterm"

    (testpath/"filterfile.jq").write '["foo", "bar", "baz"] | sort | add'
    output_log = testpath/"output.log"

    require "expect"
    require "pty"
    PTY.spawn(bin/"ijq", "-H", "", "-M", "-n", "-f", "filterfile.jq",
              [:out, :err] => output_log.to_s) do |r, w, pid|
      refute_nil r.expect("barbazfoo", 5), "Expected barbazfoo"
      w.write "\r"
      r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      r.close
      w.close
      Process.wait(pid)
    end
    assert_match "\"barbazfoo\"", output_log.read
  end
end