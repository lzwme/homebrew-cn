class Ferron < Formula
  desc "Fast, memory-safe web server written in Rust"
  homepage "https://www.ferronweb.org/"
  url "https://ghfast.top/https://github.com/ferronweb/ferron/archive/refs/tags/1.3.6.tar.gz"
  sha256 "323ebee7cb4deec64b1998da885fee1bc415fddbf2891463cfceb0412f0d3881"
  license "MIT"
  head "https://github.com/ferronweb/ferron.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d64d431c5155adda2727fdfa97876ea41d9679612e85472e714208eb4dd6b76a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d08dd0f7e69ddc1f754911f1e8a1535e69b4640c7f550f5f4012ee6773d1d0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa8f2cafe6f43e0ba74bb36bb2541e541e00d49353152fb63b035e1735bd6889"
    sha256 cellar: :any_skip_relocation, sonoma:        "26a7ab06def898a04aa62aa9db5d6058306a4fafaa586f7015c6384ce66add26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "609fc4c24bc1626f9145f8ca26c55f86240f8151eb51856b815a5e4240c0bf72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f4f81bf58e52902b641712c9e469ff86680103170011884b9fea865c49da6f2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "ferron")
  end

  test do
    port = free_port

    (testpath/"ferron.yaml").write "global: {\"port\":#{port}}"
    expected_output = <<~HTML.chomp
      <!DOCTYPE html>
      <html lang="en">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>404 Not Found</title>
      </head>
      <body>
          <h1>404 Not Found</h1>
          <p>The requested resource wasn't found. Double-check the URL if entered manually.</p>
      </body>
      </html>
    HTML

    begin
      pid = spawn bin/"ferron", "-c", testpath/"ferron.yaml"
      sleep 3
      assert_match expected_output, shell_output("curl -s 127.0.0.1:#{port}")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end