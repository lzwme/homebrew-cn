class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://ghfast.top/https://github.com/schollz/croc/archive/refs/tags/v11.2.1.tar.gz"
  sha256 "c3e276f46755f2984cb7958cbe00e01ecf85351d2509d45067b6291abc404d29"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78dc2e2d3748d3f4f5b1e0828c2548dc7345c9185d2eab2e25af148b9ce3dd5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78dc2e2d3748d3f4f5b1e0828c2548dc7345c9185d2eab2e25af148b9ce3dd5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78dc2e2d3748d3f4f5b1e0828c2548dc7345c9185d2eab2e25af148b9ce3dd5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "da1064473b24a3e9eb3081ec2e421a0b36768b506216579589648118cc11fe75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9834e0756c43c1a8bcee3585b3f427dd59078b904d0c12abfd22f3474d49fbd3"
    sha256 cellar: :any,                 x86_64_linux:  "1076c820dcd18fc4a4f482d61cabf8c759d4fc79f30380e7940435c6564acf0d"
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