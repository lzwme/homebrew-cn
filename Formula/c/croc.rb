class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://ghfast.top/https://github.com/schollz/croc/archive/refs/tags/v11.0.2.tar.gz"
  sha256 "833c4cb804d1ebdca4594803d0bba05f5bd8663a148fa3ee9c55e3184c805abb"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8e0d09462c9621cce7c4fc2f28c0b568cb0615cd86ec55ffa2217433d75db4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8e0d09462c9621cce7c4fc2f28c0b568cb0615cd86ec55ffa2217433d75db4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8e0d09462c9621cce7c4fc2f28c0b568cb0615cd86ec55ffa2217433d75db4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "de77351f2265dd457c8bf274d6b517814bb7b22085bfb1bf18ebcbf91c8ff618"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61dfefbfe74cea4806af09ec16c01761af402e31ba42d7a29b5da6f1cd0f417e"
    sha256 cellar: :any,                 x86_64_linux:  "9915817b2dd8bf13a30b6e2273d7f441e4ac274ab6cc894f56df34766f1326b2"
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