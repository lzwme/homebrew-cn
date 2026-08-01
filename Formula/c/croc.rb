class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://ghfast.top/https://github.com/schollz/croc/archive/refs/tags/v11.0.1.tar.gz"
  sha256 "44152e31cf651a9ac2b0492573f562a2784fcf75afa7ff5a9ce815f7ec5352d0"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb06ba582b0df64fde85f18c4b4727e2fd3827b4fa09f42bffea6bff926f8f2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb06ba582b0df64fde85f18c4b4727e2fd3827b4fa09f42bffea6bff926f8f2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb06ba582b0df64fde85f18c4b4727e2fd3827b4fa09f42bffea6bff926f8f2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf2d38132d0e247dc90d8695f942f572aaa94d9f49ba904afeac11cf5dc2214c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "794b5f49d73b69bc40fff400de47122969e789469d44e532343db9e7b05ca0aa"
    sha256 cellar: :any,                 x86_64_linux:  "1891b5bed538fd53c53ef3f3613794942ba5c0b9036d3fc54a255ab47ca11b7d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    # As of https://github.com/schollz/croc/pull/701 an alternate method is used to provide the secret code
    ENV["CROC_SECRET"] = "homebrew-test"

    ports = [free_port, free_port]

    require "pty"
    pid = PTY.spawn(bin/"croc", "relay", "--ports", ports.join(",")).last
    sleep 3

    pid_send = PTY.spawn(bin/"croc", "--relay=localhost:#{ports.first}", "send",
                                     "--no-local", "--text=mytext", "--transfers=1").last
    sleep 3

    output = shell_output("#{bin}/croc --relay localhost:#{ports.first} --overwrite --yes")
    assert_match "mytext", output
  ensure
    Process.kill("TERM", pid_send)
    Process.kill("TERM", pid)
    Process.wait(pid_send)
    Process.wait(pid)
  end
end