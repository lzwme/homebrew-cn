class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https:github.comMyriad-Dreamintinymist"
  url "https:github.comMyriad-Dreamintinymistarchiverefstagsv0.11.20.tar.gz"
  sha256 "19d28b1c7c9fed755a3bf599c9dc4147755b7ff12a329a328fa392db10af4bb6"
  license "Apache-2.0"
  head "https:github.comMyriad-Dreamintinymist.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bc72e3502a4e8376c150d31435bf1ef262c8782cdd22124ee33c301dfbe0b196"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5dbe220c73cbb2c16819961dabd61c869c15cd0c09b3dca1558caaefa6e02da7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1e6dc9850a7bacfa8340bbc79b39ad4c3bce045d61b7134aab24439c8a0cd78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23d56e80b57d48ccba473a4903c9b1296731ffb6f0d96b99cee3775770712b70"
    sha256 cellar: :any_skip_relocation, sonoma:         "3719086352ff4c2e8316e8750c57c0a32c845bbef4f2dbee3104aad95324845d"
    sha256 cellar: :any_skip_relocation, ventura:        "7c627dee7a902528344d888ed9a6a578531cfc634d664d580dc303e2d204e95b"
    sha256 cellar: :any_skip_relocation, monterey:       "9d80704a40787f9350959d1553b87de06f4a55f66805407e2fa020ebb33937ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be31d2a3086fd27c33afe6e39eba0226382d234802ccfe2b341291236ff8e881"
  end

  depends_on "rust" => :build

  def install
    cd "cratestinymist" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = IO.popen(bin"tinymist", "w+") do |pipe|
      pipe.write(input)
      sleep 1
      pipe.close_write
      pipe.read
    end

    assert_match(^Content-Length: \d+i, output)
    json_dump = output.lines.last.strip
    assert_equal 1, JSON.parse(json_dump)["id"]
  end
end