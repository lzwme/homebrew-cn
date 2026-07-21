class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://ghfast.top/https://github.com/schollz/croc/archive/refs/tags/v10.4.14.tar.gz"
  sha256 "3280b690b81520837e4b17bbc4fa3116ad8d534229e4d8ec2bdf017a2ca7755a"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a0768efe1b7d62b2b348f8b26ab7cb623ed090110c09bf7de0e2c983c0ed8ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a0768efe1b7d62b2b348f8b26ab7cb623ed090110c09bf7de0e2c983c0ed8ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a0768efe1b7d62b2b348f8b26ab7cb623ed090110c09bf7de0e2c983c0ed8ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "76cbd4157d01e38ce4d3316d632fc70c112817bca7bfbb8834c5ef63f8642c0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1aac848e77aa20bceda0f21a2f49683efaeeb662e57ec46e71028c9aeef8c505"
    sha256 cellar: :any,                 x86_64_linux:  "a274bc0b00bdf7a72bf500981d873e8d80a047fe24af5cad24a6bad5436b8c32"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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