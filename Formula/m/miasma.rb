class Miasma < Formula
  desc "Trap AI web scrapers in an endless poison pit"
  homepage "https://github.com/austin-weeks/miasma"
  url "https://ghfast.top/https://github.com/austin-weeks/miasma/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "081bdccc2cfe1a9889dbb842006a4ee6fb5764dd5835a42955d46f36d8ba3db2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b23fa9fb097c0bb070daa070d29f7555f504f851dfad804632c5fc0a3bdd4a31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "483be9679c5633dc9d9f8a18a7660eaaf7a9a849adc7ae67ff76f6b39163abf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d6950283bcda86e503cbf1549861f46595d56031fc79fa4c25123485317a8f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "154af996816185e10b9202672020cbf9b988f08ec5eedb9e7e68360f6347259c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18d99ab3815f333b67df3b125eb7397e1a6aa023ebd9d33d2fb095ea7a89d4c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cfaa70dc5a5b1a3a1cd1906053b28ae754dbb7f88ace50c30049ce8f7dad38a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    pid = spawn bin/"miasma", "--host", "127.0.0.1", "--port", port.to_s

    # give the server a second to start up
    sleep 3
    system "curl", "-sSf", "http://127.0.0.1:#{port}/"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end