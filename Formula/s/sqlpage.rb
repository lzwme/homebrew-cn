class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://ghproxy.com/https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "b174f8e5b0d03adb04cfc9cacfa20f33cc482f41257f9d934d8d1628ed300322"
  license "MIT"
  head "https://github.com/lovasoa/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1a16a5500876afe2294682248b5e8b520959b6cebb306de3d29666368825b88"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0a755299760662b2827c68a3c26bc6b1691cc776818aea6bd556ec380c2c9e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8ef6689fb15dbb3f7e080863d15059c46bbab11e443d7c180b151bcd705c68b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a92fbb41d16809be1da0b8aba1f8f2bdc9064c0aa6bd804247ee3d88507713b0"
    sha256 cellar: :any_skip_relocation, ventura:        "4a4f4836f07e0c23b753a32c05e41069d95f75eddcfbe3986b8bd2c69ccf6127"
    sha256 cellar: :any_skip_relocation, monterey:       "a3b22f0f1026329b9684479cf7cc7c19bb9c1976075cab046330e1442e4fd28f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19e5d0dd208a791fe2cc14002eaf99cd8ac009b2ee9a4fd277a769fd6076830e"
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