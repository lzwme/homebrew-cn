class Ferron < Formula
  desc "Fast, memory-safe web server written in Rust"
  homepage "https:www.ferronweb.org"
  url "https:github.comferronwebferronarchiverefstags1.3.2.tar.gz"
  sha256 "bcaa4859bd7197f3bd0cb020831b4634f00c5cc774206209924522695cdacfe8"
  license "MIT"
  head "https:github.comferronwebferron.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e98eaffd6a081ccb49931f1c94665a17b6bf9f3d05081df2bf4f64d95816c7e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8cfa35abd41bcad3933d9c98e6a444716d43ddf02265fcc10a51bd17377b44a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9546e8a4828aa366984223a47254e00e054e297e49d3b383819b1766e9e98a82"
    sha256 cellar: :any_skip_relocation, sonoma:        "39640d38c65db25c08d71bcbd3a0c8a7c151af1f7ec61d90b54a32bf54030ef2"
    sha256 cellar: :any_skip_relocation, ventura:       "66dcdee5085887ac91c00770f79862bebf4bfcbfb97cde21e4f277ad55e58525"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ceb8fd6a569a7ed357623ac2036cba598ed5174b37b0c8da0654c809b4f5e14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7039c4387a151c8d906a5466c450bd3e02dfcb124f03093a3609950098c3676"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "ferron")
  end

  test do
    port = free_port

    (testpath"ferron.yaml").write "global: {\"port\":#{port}}"
    expected_output = <<~HTML.chomp
      <!DOCTYPE html>
      <html lang="en">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>404 Not Found<title>
      <head>
      <body>
          <h1>404 Not Found<h1>
          <p>The requested resource wasn't found. Double-check the URL if entered manually.<p>
      <body>
      <html>
    HTML

    begin
      pid = spawn bin"ferron", "-c", testpath"ferron.yaml"
      sleep 3
      assert_match expected_output, shell_output("curl -s 127.0.0.1:#{port}")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end