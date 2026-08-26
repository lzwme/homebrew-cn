class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://ghfast.top/https://github.com/schollz/croc/archive/refs/tags/v11.3.2.tar.gz"
  sha256 "441f751cc45d0a66312a54bf5374a6f30e95992e0d71c808d5aaadb62f74cd67"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87e5c43738af4ead9593525e23959bc227468e8e32319ae50316d31b6eeaa5d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87e5c43738af4ead9593525e23959bc227468e8e32319ae50316d31b6eeaa5d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87e5c43738af4ead9593525e23959bc227468e8e32319ae50316d31b6eeaa5d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3d6cae9d46d206b772ed081ca443bdf676ee02d8592e16d8d852930f01fce38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06830a4a32b6d607de80bb491783a28c0ccc32e5ad5882f7e8845f0dd44f986e"
    sha256 cellar: :any,                 x86_64_linux:  "7b070a66ecc67ff2ef3c6ec0d79f8a7d1c423bedea3e540f11d23e16694ba395"
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