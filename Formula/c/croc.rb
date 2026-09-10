class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://ghfast.top/https://github.com/schollz/croc/archive/refs/tags/v11.5.2.tar.gz"
  sha256 "2ceddb504be8b5912f4a3bfd76dc28bb18afda54191f2bebcf5b0fb24e63f774"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b871ef0aa22dad8b384332c1270cf8f8812722d49d6e5dad3293ac3b2bbbc2b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "358403b0e500576fd6dac87aff40ad8a88f17ca19d5d43f07265f35b70a34ecb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a64f87ee1c5e5d73c6fc9012b0f106b2e8d5b2d1e1c29a619ede8d08a6356b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3827af789c8c7692bdd3bfafc0d85a11c2f56dbe76a0c3a56af9f7bd92083322"
    sha256 cellar: :any,                 x86_64_linux:  "8b7de69b7e87d49e6d104b9bd73aafcec9eb6c62a1b2ad11f59e091c35445cf6"
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