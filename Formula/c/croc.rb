class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://ghfast.top/https://github.com/schollz/croc/archive/refs/tags/v11.3.3.tar.gz"
  sha256 "13218971aa54b34def16288c70417ab5b2653d5f68082f77445b4b8963ebb430"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b966ddd89df7a43330acf847739fdaae29bc27417e6ec2b612206ec824d33c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1355c2292846f36806016dd6aa917c80cf9e9d5f62e54f862d8c9c0b287e9fa6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c599b80a092f98902fc2c6c75c678f6cd551f49f8e67a878ab497db5634d0ff4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d66d183c6d1027be1fe83ed44e0e82cb925df5268d05355ea8c5709e87bc4ec9"
    sha256 cellar: :any,                 x86_64_linux:  "1b24d959c5ac2b52b2db364e74f8f4a531f18502c7e076496673207979b6d73c"
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