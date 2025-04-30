class Ferron < Formula
  desc "Fast, memory-safe web server written in Rust"
  homepage "https:www.ferronweb.org"
  url "https:github.comferronwebferronarchiverefstags1.1.1.tar.gz"
  sha256 "8fe84708dc14b452de060449aaf550cda922a862b4e3bb05ad971faf92f92f77"
  license "MIT"
  head "https:github.comferronwebferron.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a02992a1ff6a34646d68b6ecea9a19ac17b208e95ea5cbde0316445ab5600c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3533428b44bddf4b43ff13ae73e21b71d3a501fe0cb8e8da181eb05294e494d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1235dc68f94decab40fd2f7508f52de9b90e77b60a123bac476fe17096ba3454"
    sha256 cellar: :any_skip_relocation, sonoma:        "f39a6dc376db7b50dfcde862c6acec7ea88819c7de70539b1db23a3c68788c6b"
    sha256 cellar: :any_skip_relocation, ventura:       "7d5618f8cc5f8868f010ebc851222fb010ab2646329a94301cabb115f08defe8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54b083ba406fd1a638123816d5967ed0e8515d8a0d929cf45efca76bae186815"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47a4e6cef48eed37b7f48cc2586f5cd384066aa25d8b63f10237aeb9ac958c86"
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