class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://ghfast.top/https://github.com/schollz/croc/archive/refs/tags/v11.5.0.tar.gz"
  sha256 "ecca279d7144e8f9052836cd672af359fc93c8bac4d7a8f0b2a16225f7b91cf2"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "517e7821514e93296d04f26327bdeae6e05ae6d5e465e4d63653c16cc3a83cec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3a20c5ab195d56aae3b4d6417d26d490edba77cd1334f6e9b41fa3f52a92b16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d70c45ebbda659c710856e885d62d2edc20b36c2501cafeb1e87e0debd4877d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a72020b125f7fce24db2f3447040744b40daa4aa651558adadf9f33b684f4d8a"
    sha256 cellar: :any,                 x86_64_linux:  "92f6b80f33f167c383b0935e30f22553b147dae2deba74857b3683d1f3add6be"
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