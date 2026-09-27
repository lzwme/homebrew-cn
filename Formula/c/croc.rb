class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://ghfast.top/https://github.com/schollz/croc/archive/refs/tags/v11.5.4.tar.gz"
  sha256 "16910b594704b40e9df35eb3bc637db675fe3d770a4588bd32b5a12c5ff174ff"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "386c533c610d3374ff881e2ea1e6a0c660c45ad2411d0b9c33686f03f8274b25"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "49255f03b6680020b7d87c445208ce1fe292db68dbef3242bc920ec3e277e97c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4c5c6ae39d46ea35921d5631bb458a705d77fe6ece7babd757ab54c9067d0b0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "07357755e5ce701786cc82311c621449694e793b9b02ab1e709f8e5f1df3e8f8"
    sha256 cellar: :any,                 x86_64_linux:      "ed67ed30488fafd8ba352652b4a5ebf9e252db871fd66162528a9c1faa65b8e8"
  end

  depends_on "go" => :build

  # `test do` block runs a local relay
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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