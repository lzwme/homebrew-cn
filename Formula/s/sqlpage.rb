class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://ghproxy.com/https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "713087423a1a8653cc48fd988e81997f76e6b2b8073a9007e23995a3a8fa5e3b"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e30be158e73a1b515ed1c96fbec42751dec4fd3c3e8f0476da7bc40daad959c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7da8000533302109f80560144cecf5841396354428036904099ef84654424782"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "680e8e661788d2136049a63af05dca91c8587668d1694711439b5ef69a75a3b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "fcff99e1ae73e62baf70b06423dc77b0631899d154c229f07d52c556061a58b4"
    sha256 cellar: :any_skip_relocation, ventura:        "5e4ff3cec21e51d24a73b64b87e1590655ef9d14c0ca2b4368b4985eee77ca5a"
    sha256 cellar: :any_skip_relocation, monterey:       "6206c6dce543d392b162f4b8e96d635e854f5bd838686a4d480ac3419d9fa59a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35acd3876dd9330ce81d47e9ad377ebc60342fc45f662ac39f49b0ee81894eab"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    pid = fork do
      ENV["PORT"] = port.to_s
      exec "sqlpage"
    end
    sleep(2)
    assert_match "It works", shell_output("curl -s http://localhost:#{port}")
    Process.kill(9, pid)
  end
end