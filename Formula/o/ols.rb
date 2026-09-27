class Ols < Formula
  desc "Language server for The Odin Programming Language"
  homepage "https://github.com/DanielGavin/ols"
  url "https://ghfast.top/https://github.com/DanielGavin/ols/archive/refs/tags/dev-2026-08.tar.gz"
  sha256 "e8d368f35b6833efa7e840753881d01f76607f3c0872c614e536f2b7e939f800"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d1eea32145df80d1bba93312ec2f550b41dcedb3aab32265522e029fe09a3d86"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0a5a601616565b0bdcfaa484ffe0f589677848e88592b16722d48febeaa01b91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "52f49213b3a19715408ff48c32af6105d876955e22ccb39b60c4f11eacdc0007"
    sha256 cellar: :any,                 arm64_linux:       "12d2f63811a29d6d45042aa194651bd77d843038d925be9bb926062d67d22fd9"
    sha256 cellar: :any,                 x86_64_linux:      "d454e3a6cc1e7d657c826533524b87b56bbf3b728775b68319515a743a253f72"
  end

  depends_on "odin" => :build

  # Backport build fix for odin 2026-09, which replaced `ast.Inline_Asm_Expr` with `ast.Asm_Template`
  patch do
    url "https://github.com/DanielGavin/ols/commit/5f1b4d773b05d98dc9533521490096cf1a06a6d3.patch?full_index=1"
    sha256 "e76914e29a26bca835d115111c1017ec0e6f7d51edc93a8c0e1f9a1fbd7c6368"
    type :backport
    resolves "https://github.com/DanielGavin/ols/pull/1653"
  end

  def install
    args = %W[
      -out:ols
      -collection:src=src
      -define:VERSION=#{version}
      -o:speed
      -no-bounds-check
    ]
    # Odin defaults to x86-64-v2, which is newer than Homebrew's oldest supported x86_64 CPU
    args << "-microarch:#{ENV.effective_arch}" if Hardware::CPU.intel?
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