class Ols < Formula
  desc "Language server for The Odin Programming Language"
  homepage "https://github.com/DanielGavin/ols"
  url "https://ghfast.top/https://github.com/DanielGavin/ols/archive/refs/tags/dev-2026-03.tar.gz"
  version "dev-2026-03"
  sha256 "7c0d9e0312d5dc0d49e1696b98217932838e1b132feb2a68950e6fa7d6d4a2ea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0ce90f81fc0649e4f209da48b1c1fb6830d3216dc69bb8670adf6a7d39ad6bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3861137355135b4f4f52f17218deb2a954a7f5f4a284cd31be7f0ea078a6909b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "479b60d55bbb1c87f4c50c1b984919032bb55a09e794d38ba65de721dcd624fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "05b95527be6fd8d8055f945bf51e990982ef94018dcd1c61075dc06be3927f2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9022556c3e1970773588b6ab4c734d3962dc17a651c2b408775b15c905b9f43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1707031f8b6716608ee0300787222965f5a76912ebf17c48d0819c05dfb58be"
  end

  depends_on "odin" => :build

  def install
    args = %W[
      -out:ols
      -collection:src=src
      -define:VERSION=#{version}
      -microarch:native
      -o:speed
      -no-bounds-check
    ]
    system "odin", "build", "src/", *args

    libexec.install "ols"
    pkgshare.install "builtin"
    (bin/"ols").write_env_script libexec/"ols", OLS_BUILTIN_FOLDER: pkgshare/"builtin"
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

    output = IO.popen(bin/"ols", "w+") do |pipe|
      pipe.write(input)
      pipe.close_write
      sleep 1
      result = pipe.read_nonblock(65536)
      Process.kill("TERM", pipe.pid)
      result
    end

    assert_match(/^Content-Length: \d+/i, output)
    json_dump = output.lines.last.strip
    assert_equal 1, JSON.parse(json_dump)["id"]
  end
end