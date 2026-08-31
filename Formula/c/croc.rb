class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://ghfast.top/https://github.com/schollz/croc/archive/refs/tags/v11.3.6.tar.gz"
  sha256 "bedca93ce041ed3e5c8d9f7add8cac25d03b97586eac14e54f3f41fe6eb70081"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a98a5e7a372c9a6bc3ef9903a1f6b3db639515d19d3487a60f37e086c829413"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0f1f64ad531096c35aa5fa194991557ccc7aade2136e7802703795b24e54968"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2bff8e7585d1dc26e29e598c6d8eea438735c930e019e98a74f7789acc9a49c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa55498db400a44703e38bb260ed62b1ed3de1b49244d46e6d6b4063bf33a40e"
    sha256 cellar: :any,                 x86_64_linux:  "d040a444dbe69c3be1a90ee87411a150cbc3a856cdc166fd201289b2d32f34ca"
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