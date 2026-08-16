class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://ghfast.top/https://github.com/schollz/croc/archive/refs/tags/v11.1.1.tar.gz"
  sha256 "bfdaa4641b35f1cd232c2d4440752014dee5e08c2ea12977b5bec933c796ca95"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6be6014c9d5cb2ec3c9b4e8fd3ecbeafe5b9af87af66662989426c0389e3de5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6be6014c9d5cb2ec3c9b4e8fd3ecbeafe5b9af87af66662989426c0389e3de5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6be6014c9d5cb2ec3c9b4e8fd3ecbeafe5b9af87af66662989426c0389e3de5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d2911b362de1e0cc913e78e9eebb71f2d6ff0234907f78678fc64abc8686a0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8a29cf907fc532ab9149594e36a9669c8fe15171f468cb99a2e5afbe2bffec1"
    sha256 cellar: :any,                 x86_64_linux:  "8146a0fdc0c807c4942cecf6c5a85caec69e861612e97b70b2af16750ee099b3"
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