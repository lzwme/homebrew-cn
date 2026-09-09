class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://ghfast.top/https://github.com/schollz/croc/archive/refs/tags/v11.5.1.tar.gz"
  sha256 "7f1ff12d55ac971e7ab85e230313fc25a996ac4f4c103d6cf336edb23e0d63b4"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd3bb352b325dd9d2f8a257d4c39281c6c5f55a68875e04a267927f33f976c32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c2d918fe0947a7e5dcb30b4338fd44bf27c0d48f0ae066126f07bc74d98659a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "036668832cad1eabbbb90657d20ad99fc78d3fe77c67c6e59b83c7c91a00cc9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28c9e5d573acbae392e65e8f3c8473876dbac8cb85d46cbb97a9105b61c14213"
    sha256 cellar: :any,                 x86_64_linux:  "6992a89b7e679f3469036741d149f14b59349ef587f1f87f907132c894ffadf3"
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