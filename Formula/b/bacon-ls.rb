class BaconLs < Formula
  desc "Rust diagnostic provider based on Bacon"
  homepage "https:github.comcrisidevbacon-ls"
  url "https:github.comcrisidevbacon-lsarchiverefstags0.20.1.tar.gz"
  sha256 "610d9c6349df44b48c1c4c8422ae75db1173186827f36f003c6d86dbf1abd167"
  license "MIT"
  head "https:github.comcrisidevbacon-ls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55ef2bb8c5c8a394c57d142c800c661870172c362fbbed407163ad73a663aa90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dca85d9993ec2f5d9c6f6eae8d5cedee5499e72f648159d9191520348204f557"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59077f5a78369e1ff45d74589724a7be7458e77d29244eb7b90c1c68bab26bc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bd5d1370ed148b3a228072fc1a1da5128ebb036f043c86ffec9b61f8e9c0138"
    sha256 cellar: :any_skip_relocation, ventura:       "b7d46e8d308b63da729581e075b1f5887c81dc0967179a8a248a98c623f7ce0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e0f75d33507f3b4c2732debb7b0c6dea7b94d190568553dd7fd4bc4d60a7085"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01dc09342f39d85138f791bfd2cd24af7bc3e2f88c1a1e7e75a93952c168fa97"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "open3"

    assert_match version.to_s, shell_output("#{bin}bacon-ls --version")

    init_json = <<~JSON
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

    Open3.popen3(bin"bacon-ls") do |stdin, stdout, _|
      stdin.write "Content-Length: #{init_json.bytesize}\r\n\r\n#{init_json}"
      stdin.close

      assert_match(^Content-Length: \d+i, stdout.read)
    end
  end
end