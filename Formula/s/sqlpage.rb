class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://ghproxy.com/https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "e0a9ebe1ddce49dfae6b14d4e884ff77168e67deca24c78034da10f689b43fbc"
  license "MIT"
  head "https://github.com/lovasoa/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4918b86bd78098c27e15d3018ea6209887ff0ee2b4c3a523278b7ecbc4ac970a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a021601e831c2ed26a9db4a35c95479bc6f36e7d4b8d9862dca3c8544f06dba9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cfb16e9b5430b0fe09f6f26875685eaf0c80f09cbfe368d1e7bae33b1a2b826"
    sha256 cellar: :any_skip_relocation, sonoma:         "8958435554531b94beac92d1556a106ee1fe205aab3afbffdf50dd96dea62356"
    sha256 cellar: :any_skip_relocation, ventura:        "b63690ae0654fa53a1406e7b69d5fdc28625b9ba593ae0899f5e7b635561bc1b"
    sha256 cellar: :any_skip_relocation, monterey:       "37f6c46a134cbedbf6014fd1e42c5638cbae7be06d1c56957c3578095d48f417"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35e93de804c59d77672a7ac75dafa923b97c7c1f81178d8ac91a7a8e75fcfd86"
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