class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://ghfast.top/https://github.com/schollz/croc/archive/refs/tags/v10.4.13.tar.gz"
  sha256 "6c65f5c60d2cc3e189edcdeb791e83f7ee6cf398c5c4437273320d0221d0fff8"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62bd5b59ee027204b98604423d32f0d575f228ddb7dd8b098f30f7c0742aa3b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62bd5b59ee027204b98604423d32f0d575f228ddb7dd8b098f30f7c0742aa3b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62bd5b59ee027204b98604423d32f0d575f228ddb7dd8b098f30f7c0742aa3b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe4bc530675e1a2e99be1f32ff8699f52a0afb3972f1b3b29fac839e730b5863"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c797a6e56eed281a8374ad36e2e00c17ab667385515d62971f0264d10e833e6"
    sha256 cellar: :any,                 x86_64_linux:  "3c3f749fbbc20002c4c8d0e6cfdfe4131638de727983f89e581160078fa2bd52"
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