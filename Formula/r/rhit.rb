class Rhit < Formula
  desc "Nginx log explorer"
  homepage "https://dystroy.org/rhit/"
  url "https://ghproxy.com/https://github.com/Canop/rhit/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "c95e10c48be82f34481bf85173148e5b9ecb649a0cae4541c449bb6605ebd085"
  license "MIT"
  head "https://github.com/Canop/rhit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b095b1084475f0e53b0b4c78eccc20c8f1f159fdd24567bb6af884379ebb34d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b004d5005f4e4d85bb89ded25fc48106f85dc012b9ba95b1bf68a74044835faa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7fb594ffb5801ed36eda5d75ec8202bb3040893295645b4aca516653843c287c"
    sha256 cellar: :any_skip_relocation, ventura:        "a34eabc996ad935771947ec3adb143c16ac0d18b18bd5bae3d37875154c66be8"
    sha256 cellar: :any_skip_relocation, monterey:       "0bddb4ca7414065f49c8f02c7a576840203141951eb1e0861adeae7abcee7c9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d861b8b79d99aee5cb7f21750b18f9ea41d1b1d8551af363105b1038e88c4548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eec4c23d683ace387844659c873a1d32d295afbfc0d4335f89c33878215da35c"
  end

  depends_on "rust" => :build

  resource "homebrew-testdata" do
    url "https://ghproxy.com/https://raw.githubusercontent.com/Canop/rhit/c78d63b/test-data/access.log"
    sha256 "e9ec07d6c7267ec326aa3f28a02a8140215c2c769ac2fe51b6294152644165eb"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"

    resource("homebrew-testdata").stage do
      output = ""
      PTY.spawn("#{bin}/rhit --silent-load --length 0 --color no access.log") do |r, _w, _pid|
        r.winsize = [80, 130]
        begin
          r.each_line { |line| output += line.gsub(/\r?\n/, "\n") }
        rescue Errno::EIO
          # GNU/Linux raises EIO when read is done on closed pty
        end
      end

      assert_match <<~EOS, output
        33,468 hits and 405M from 2021/01/22 to 2021/01/22
        ┌──────────┬──────┬─────┬────────────────────┐
        │   date   │ hits │bytes│0                33K│
        ├──────────┼──────┼─────┼────────────────────┤
        │2021/01/22│33,468│ 405M│████████████████████│
        └──────────┴──────┴─────┴────────────────────┘
      EOS
      assert_match <<~EOS, output
        HTTP status codes:
        ┌─────┬─────┬────┬────┐
        │ 2xx │ 3xx │4xx │5xx │
        ├─────┼─────┼────┼────┤
        │79.1%│14.9%│1.2%│4.8%│
        └─────┴─────┴────┴────┘
      EOS
    end
  end
end