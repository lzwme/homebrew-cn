class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://ghfast.top/https://github.com/schollz/croc/archive/refs/tags/v10.4.7.tar.gz"
  sha256 "fda871fe2f0ed5fdf2248f1ab4d6d88aea08d3582a3a1d2e3e38e916662c7f22"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b20d661da255e2c5419a6248dad41160be0f7d6858a898df17ed0d2d19e956cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b20d661da255e2c5419a6248dad41160be0f7d6858a898df17ed0d2d19e956cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b20d661da255e2c5419a6248dad41160be0f7d6858a898df17ed0d2d19e956cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a9fe521ae369730754ba4293de0a6461c6128dfc75da1048f9df3d150584d9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ca6ac2d55e27eb736a0d58aa26d9f131968bb7b9b8925de663d366f54b6a91f"
    sha256 cellar: :any,                 x86_64_linux:  "9b7364af23d898ceb71e2af0a242471466cbcf9c2c54972116d8c9808ae5cd14"
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