class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https:sql.ophir.dev"
  url "https:github.comlovasoaSQLpagearchiverefstagsv0.20.2.tar.gz"
  sha256 "4ebb8b2b5c3f284b37f21c7355502354c84cdc29efa445b7bda2ac2570f8362f"
  license "MIT"
  head "https:github.comlovasoaSQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "418b4581fe4683cdf4c5f6619b73de96507488c90bd8c8a7807a5cf8a72a22df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6690b09c63fdf6c0c6b3b60443568a69720fc561f5558a014b4c23fdc077dd5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c266b899c721bf73d63660950590ba50537c79ec3fc9f2bdf5175d0a275b2cff"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e79cea46dc6ec42405d9c1c3cb2fc768bebf79de3e874cf8de81d733c9b290a"
    sha256 cellar: :any_skip_relocation, ventura:        "b53e7796b07f1c2447704921cdfbd7585bcb1280a535cda313663b44abba867e"
    sha256 cellar: :any_skip_relocation, monterey:       "73d62e61922583f627319c803ba3f0bd06ceb23ff08e238086496e07c8020829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af22bbe27a2d5e255ab2243182833720c6feb204dc2892385f7146c52350e8e6"
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
    assert_match "It works", shell_output("curl -s http:localhost:#{port}")
    Process.kill(9, pid)
  end
end