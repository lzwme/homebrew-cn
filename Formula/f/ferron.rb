class Ferron < Formula
  desc "Fast, memory-safe web server written in Rust"
  homepage "https:www.ferronweb.org"
  url "https:github.comferronwebferronarchiverefstags1.3.0.tar.gz"
  sha256 "9803aabf52f76793f48b019b88ab69fe2faa677dfed0545731cc25bb19611426"
  license "MIT"
  head "https:github.comferronwebferron.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac56061128821170b1f5eaa1db04ff807f4872e11c78d4eddc8d5b7b712992a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b553f6526f1292884a01a537923c15bbfb82e2ef34a072b71dca10992e119c79"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "58f88d6bbe7601fb8f9ea35cc96f72d36909a4496450139334b63adca7821774"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9f698bdfd63fa2fe1cafffc7d9ae358613d7e4d6b304e641d815fe172b0d840"
    sha256 cellar: :any_skip_relocation, ventura:       "52e2255ae885627275f04bf12b3802e4444ec3bde1f386f6e16522f2cc495b6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60d440829df0079a82ee36f107c19a73244309523c7e55d48c4bd40c522d8ab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b002a690bf2f1776248c53311c13af852bfde5cbd12909a27778483593ecb00"
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