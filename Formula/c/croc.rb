class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://ghfast.top/https://github.com/schollz/croc/archive/refs/tags/v11.3.5.tar.gz"
  sha256 "944868ea5000f653cfa0a5e9daf757944716aef71a367ef4de55e61f6f5c8880"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb2f0df41708a690326f809b4dccb66b42fcbc5268c97ca90da0ef9371780fa3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62e7cbed9a6950a8fe9ef6f117b727ba5ed67fbe08abec4960a063bd515d5c72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afcd72154fb207317c341d3979db9f480cb1acfed5190a890464719d4d90132b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71d2d21367c6f32e4b72afa9cac93e9dd64678f5bfd51ec913a7bbb63b7a97cb"
    sha256 cellar: :any,                 x86_64_linux:  "4cd65add62e0d632a639e633c03019566d7a38d57f11fde2084587ed6a1def38"
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