class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://ghfast.top/https://github.com/schollz/croc/archive/refs/tags/v11.0.3.tar.gz"
  sha256 "5fe8c0612a4774b63b263d1ca6391f29e435fffe9391d5649b9ba7738d7ed9be"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fad0e698a5d6afddc1a350633cdd69349eaf843cacafc71d63420dbd445eadd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fad0e698a5d6afddc1a350633cdd69349eaf843cacafc71d63420dbd445eadd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fad0e698a5d6afddc1a350633cdd69349eaf843cacafc71d63420dbd445eadd"
    sha256 cellar: :any_skip_relocation, sonoma:        "1562ea98fdeda16d47d05dfebe7c4e5d37c655142666533cbfec29ca02ce13dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "122118d4093e92caa094a80de79719af0e9faecad5d61a22ceea584a2cef1661"
    sha256 cellar: :any,                 x86_64_linux:  "660a1c4030037bb601545d20bf3baedef9bc0c705f2223575fd81590e9b13a15"
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