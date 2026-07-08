class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://ghfast.top/https://github.com/schollz/croc/archive/refs/tags/v10.4.11.tar.gz"
  sha256 "4e45794c8ecb67a595a9d60958a80806bc50b9eca04796dc24d3295e0cc9be46"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89ea26b94cef0e6b590df5c39a40f49039cfffbd717c36287eb9308bdd033a20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89ea26b94cef0e6b590df5c39a40f49039cfffbd717c36287eb9308bdd033a20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89ea26b94cef0e6b590df5c39a40f49039cfffbd717c36287eb9308bdd033a20"
    sha256 cellar: :any_skip_relocation, sonoma:        "d33d18b261bb99d2912936238f94439f4447bdca49840793034e3941acc7a11e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "952ba7f0e4598715d83e7c6d9e14b12d35013dd5bcc962cc6ff09253bd1e0f8f"
    sha256 cellar: :any,                 x86_64_linux:  "7341f31d623495a223360a553fbec62e88c0d5a516a7c2e5d284ea7cd30ba79a"
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