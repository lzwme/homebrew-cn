class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://ghfast.top/https://github.com/schollz/croc/archive/refs/tags/v11.2.5.tar.gz"
  sha256 "f26633248287928f1af8755bd92bf366af5feaf10e4bba0ce53f7ad2c57b3372"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e53cfae806c8d10b730757de7bc3dffb83f705edcff837cc912420c193b23bb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e53cfae806c8d10b730757de7bc3dffb83f705edcff837cc912420c193b23bb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e53cfae806c8d10b730757de7bc3dffb83f705edcff837cc912420c193b23bb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d33ce7993c713b680f03467582ae0f22a005cef17826bbca9ddf8a6e8988017e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27e81754ab6d5dacd7d890970a975bf28ffae74318994a31a0cd877975d72f37"
    sha256 cellar: :any,                 x86_64_linux:  "dd9fc082957f3f85b1c7203004a17e0ef56a764aa07c1ba1f362be1c5a6d44b7"
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