class Rhit < Formula
  desc "Nginx log explorer"
  homepage "https:dystroy.orgrhit"
  url "https:github.comCanoprhitarchiverefstagsv2.0.2.tar.gz"
  sha256 "df66222b70e9f84d8e7af0916a5df6b346139ba78ee4bbd26d5e5e1fb3c9ddfc"
  license "MIT"
  head "https:github.comCanoprhit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cacb61ec43357ad044b6350841ea92fc66badbc2140723b30611517d977d882d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d5f43e930d1d64d3b128e891d80f737f0ab80cfc41968aabdafa541557b95e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20104e46446720d9a8b5d38f89b365114e3023c4f91cad1c90493a8cd210e696"
    sha256 cellar: :any_skip_relocation, sonoma:         "35dc3ca082da24aa64bebc49b725f7b4ffee899ac512cbeb78d98115ab72d639"
    sha256 cellar: :any_skip_relocation, ventura:        "9459d1cd6d1b80004abd10589bcef3c4ac168851bb579aaa77aa71db8d47765b"
    sha256 cellar: :any_skip_relocation, monterey:       "55b97eaeb16a6e90dc57efd19e7f1a027c12b91df93d7f6b29bad637d94fb583"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9595fa93164dd8f63c6cbddc6f2eca6e40f7b44ac7e46d312edfd421e030866"
  end

  depends_on "rust" => :build

  resource "homebrew-testdata" do
    url "https:raw.githubusercontent.comCanoprhitc78d63btest-dataaccess.log"
    sha256 "e9ec07d6c7267ec326aa3f28a02a8140215c2c769ac2fe51b6294152644165eb"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "ioconsole"

    resource("homebrew-testdata").stage do
      output = ""
      PTY.spawn("#{bin}rhit --silent-load --length 0 --color no access.log") do |r, _w, _pid|
        r.winsize = [80, 130]
        begin
          r.each_line { |line| output += line.gsub(\r?\n, "\n") }
        rescue Errno::EIO
          # GNULinux raises EIO when read is done on closed pty
        end
      end

      assert_match <<~EOS, output
        33,468 hits and 405M from 20210122 to 20210122
        ┌──────────┬──────┬─────┬────────────────────┐
        │   date   │ hits │bytes│0                33K│
        ├──────────┼──────┼─────┼────────────────────┤
        │20210122│33,468│ 405M│████████████████████│
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