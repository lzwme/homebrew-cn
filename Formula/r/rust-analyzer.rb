class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2025-04-14",
       revision: "8365cf853e791c93fa8bc924f031f11949bb1a3c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a6b6d9b32e1c075c20720cfba1ae1674e7b698d79ff32161bf94be51f666595"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad226d0a4665a2b1656d0d8460bf13adb2670cad7cda9c7ee4cff4334d8764bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "17c907c10da9da9f4d8bd5c5fb52555606b0064c15c09b6526af573a20f3dde0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1f799b34911a9d20e917a6f7b6a30dafc8cae07fee0ca61313ded8c258936f6"
    sha256 cellar: :any_skip_relocation, ventura:       "d25627beb004a3101a18fab3d2c4929f844796eaa6a3047096c5a3acf36f8e40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a66cc21df19174563fdf5065418f847961aa3e6cb957c4b886f7e5fde76548c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2bd28b4b32d07371b92f707e917a9c4e1d06cb6eb70cecbde00d72865f09f8f"
  end

  depends_on "rust" => :build

  def install
    cd "cratesrust-analyzer" do
      system "cargo", "install", "--bin", "rust-analyzer", *std_cargo_args
    end
  end

  def rpc(json)
    "Content-Length: #{json.size}\r\n" \
      "\r\n" \
      "#{json}"
  end

  test do
    input = rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id":1,
        "method":"initialize",
        "params": {
          "rootUri": "file:devnull",
          "capabilities": {}
        }
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"initialized",
        "params": {}
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id": 1,
        "method":"shutdown",
        "params": null
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"exit",
        "params": {}
      }
    JSON

    output = Content-Length: \d+\r\n\r\n

    assert_match output, pipe_output(bin"rust-analyzer", input, 0)
  end
end