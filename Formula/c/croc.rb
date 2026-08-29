class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://ghfast.top/https://github.com/schollz/croc/archive/refs/tags/v11.3.4.tar.gz"
  sha256 "f851e1e85fa04be3fbe9c1aef11b1da7c6c90fc59986cc498169569abbbd33bc"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16ced63afd71193750b5dbe7223d38a5b2ae37e21f2c760abb123c8a354ecbce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b81bfffe78e40163bf295e2c8b84c600817f5dbade64de1fddb92ceac2ae8dec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84d6129d5bdac5f3c35f5f3f573cf5d02da5911f1dccfd7dcbdd11e0df45328c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "803c21653e5bb8675edeb5bec85b7447a00e4a5a470779aa04420ac1193b4e72"
    sha256 cellar: :any,                 x86_64_linux:  "2e3081389ba96a9f38e6f5e1092636ccdc23be634e25cea088689e7fd319f94d"
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