class BaconLs < Formula
  desc "Rust diagnostic provider based on Bacon"
  homepage "https:github.comcrisidevbacon-ls"
  url "https:github.comcrisidevbacon-lsarchiverefstags0.17.0.tar.gz"
  sha256 "ef4e343d9fe8f98364304d493e581a08d3f9b1edfd6c96d80c8d62dd1f226309"
  license "MIT"
  head "https:github.comcrisidevbacon-ls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d84423dac9c3f03feedfe8f1e2e2ed4f911e6221b77baec533a2b0637383808a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b20233e53a19f7fd7e732f2763f2ab86d2971c6af67dcf99be37602a6c7f4681"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "440fa5ee618049d95b59a07fdfc1fd54d19a28df8bf3c399906b477661461459"
    sha256 cellar: :any_skip_relocation, sonoma:        "90f2f785217f8bd191edfee3487348aa9af740b955787c73abf7a422978e12f3"
    sha256 cellar: :any_skip_relocation, ventura:       "06e7b56d5c48ff01ec2122e1f31b152a4a613a64d33c378ec58a23a252840b4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9326c99d012c82632ba760173e85c75b0f3d8749cd6a86c5f5b5093805ab5ff2"
  end

  depends_on "rust" => :build

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