class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://ghfast.top/https://github.com/schollz/croc/archive/refs/tags/v11.1.0.tar.gz"
  sha256 "ae71b65f54c48fd2f4d60bb0209a0a18584bb0c744967675b0a0d4f2ffb22e8f"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a5ca0ceee6a3df814600b346f3f357b3456fad583bb016e602c87adf0048329"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a5ca0ceee6a3df814600b346f3f357b3456fad583bb016e602c87adf0048329"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a5ca0ceee6a3df814600b346f3f357b3456fad583bb016e602c87adf0048329"
    sha256 cellar: :any_skip_relocation, sonoma:        "62030bde59fedaea0290b45491e7b2d1f7ea80b52507523cddd39265dd1b2810"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8de3a355eb7f1396a15d03d9275387781c7c7bd3af95ecc4d30776cc85b31090"
    sha256 cellar: :any,                 x86_64_linux:  "59973e27b1cfba1258b259438a114a4f6f2cc5504377e75e2c18788d7d61920a"
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