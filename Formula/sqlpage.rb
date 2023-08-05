class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://ghproxy.com/https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "169808dd5c53b6474aaf0fe2ad00a4358d5898015d18bcabc9770facdf999fa1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5e7dc4fafaf2cd2ac0f6db06a5fa34f1a886150406d22bfbeba609afd356763"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcf670ed9055aff09c501a33cd196943eac91e1110a7ae9d97bd15c0edac0ed0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42dc33425ea8c1223b70d71084b7018b178a79068bff160c98ef96a8ec3a6683"
    sha256 cellar: :any_skip_relocation, ventura:        "1d41eb5458c1dd2f8fb19c8e2258e25df4b4158a1ecfc0514a79dbc05fbcac71"
    sha256 cellar: :any_skip_relocation, monterey:       "79629fd0d548c3dbd3ee68fc2d3029ffc0d2aba4d9a70c38cbfcf6f1834e780e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8e7b2cf0cd2430a9e7ccf94dac8b58e2336fbb41a54c27082987d523d75803d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3e9473a637e8855d3cbd88504ebfdee21f16717be8ad599439547c18636451f"
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