class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://ghproxy.com/https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "13be30c4882fee1b0e49b4a3f90f52cc3da7e0d78e485d781198f5e7f604bd4d"
  license "MIT"
  head "https://github.com/lovasoa/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6b5c3ec668b3ab28080693e4f637765a66415a148bc6e037e820800fb22740c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43ae57b9eb32aefaf872842d4bed05dd4321f70b7a27f50c7abf01668a7b662b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9811f64aabb618948b22d512cf76b194e01f47b6949ba9fd005565787be290d"
    sha256 cellar: :any_skip_relocation, sonoma:         "9fad49995f72eb82fb4b6f31090ee14d24e0ad993a3dc545a9886f96311cbaaf"
    sha256 cellar: :any_skip_relocation, ventura:        "ce263ecaa7b1f6a65e63bde39f10d8fb6a97f59c3d7a1cbfaf37b17861d3b3f9"
    sha256 cellar: :any_skip_relocation, monterey:       "ab338d719e1947703f78e4963de296d13376266e983980d37a6a4acb83630dec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4bcdc99017ca52ff767a7fcef8f309789afe83fce11c0cc5cbe98b31c9a9670"
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