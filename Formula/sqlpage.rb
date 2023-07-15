class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://ghproxy.com/https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "e6f7e0fa0d96e13560f7a010e9d1df0184a2bb610f70311647ffdecea9ba671a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a34b161ef21566171d4ed9da1798cc6b84ae921fc5fb2e39bb5c8850f55c9892"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0190c027bfdd2a533d8b2e8790364a9a69f2288a4f2e6a5216a0dcf7fe9279c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c95e3bc03ca0e91be4937bcbd33b11ffb257f56767c621a931fed2478ea1b5be"
    sha256 cellar: :any_skip_relocation, ventura:        "1b0d47c5b8e2bb51d126f19a2e3ee5e644b6a9e0b3d57c8b69d68f6f7514b44c"
    sha256 cellar: :any_skip_relocation, monterey:       "f400e81da6b6e56ec8f8773b1744411a538dc2f520baa35de79d7f2501e2ee68"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c0d71bf2650e2a6261e1bb8bd0ca4c1f9b903e3edb6d5449970e64bf0ff4586"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59c1c33e3720edfe0090dd16f1f74cf2b4281e6eaaf1a105944ed2cf583fb394"
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