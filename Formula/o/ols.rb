class Ols < Formula
  desc "Language server for The Odin Programming Language"
  homepage "https://github.com/DanielGavin/ols"
  url "https://ghfast.top/https://github.com/DanielGavin/ols/archive/refs/tags/dev-2026-08.tar.gz"
  sha256 "e8d368f35b6833efa7e840753881d01f76607f3c0872c614e536f2b7e939f800"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "927060759f77faaed013fe389987cf34e42b8a0170141bf79f9f26ef8539c6bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2e2fb49c2d439e08b97777b3607102c2d3709b2d50ebe2753cde84fecebc25a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6317730fcfb6cd14d441a727bcdb8eb36b581f1ff55a079a81273c3415e2585a"
    sha256 cellar: :any,                 arm64_linux:   "1bbe3fce9f36473bf3a9282897cae48115cdb744d622b1b9dab0bd17b87b5824"
    sha256 cellar: :any,                 x86_64_linux:  "cbbf92a283039ad633160259776b4c864f0941fe1f0b1e6050be4f0744746b2f"
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