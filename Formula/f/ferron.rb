class Ferron < Formula
  desc "Fast, memory-safe web server written in Rust"
  homepage "https:www.ferronweb.org"
  url "https:github.comferronwebferronarchiverefstags1.1.2.tar.gz"
  sha256 "d39c9f5bd1b7f8952af850c029411597d62031292589d7301c883c73ec41f83a"
  license "MIT"
  head "https:github.comferronwebferron.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d560b68d5bf0c6179f9325463763eb2ea9c94ca47cad9e0b70f6f6f79ad3d581"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "323771302b725305023bbc419a04929ea36df4b0b47c48804e920311491e909f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1da2b7c869b051bfa89b0cd25f42f9743c6e130abe4a1f804f3824f1a484a2ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "438561e998dc816e6cfb4c23712fa575ff8e476f7b882d0bf5faaf66557858bc"
    sha256 cellar: :any_skip_relocation, ventura:       "5d0c548197422b08e50aea21c72813f205b5cb6df8da0c9e3bedc0209c0b479a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f832738bb57c0b5faf946d1e98ee255beea362b01c510ba80d8d77022fea530"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dceef017db09bf76418f5613cd8f1c7bdcd9681c42a39e12b120a9e616e64138"
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