class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-07-29",
       revision: "fd74511f34ae6c165466543cc6e55ea60e7365af"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc8977398029aefa5d5398bb609b851a1b3cdf6abb2d5911c20271fb160e4453"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5094d396ebd0139714be414f016d7c4e839b960b3e1527995446894d8b8fd46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0d8c62c6a2d52487c52944679b2213384ee32ad719a68eab3c18969552d62f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "571d261ab300a73ec8faa8d913da4a1407b846e6fee8aa780f9bfaabdc74e5ea"
    sha256 cellar: :any_skip_relocation, ventura:        "2f02d6f1619778d9a9881244a98958d92cb9dde855ff31b2b36b9fa8eadee2d2"
    sha256 cellar: :any_skip_relocation, monterey:       "91d9f8a96027784fdb0da3c7c66402b9e5e765d8af58400d78e6c9b0e43bb89c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61e82de2885092ef8391abb261770a46aa8827640fc71513ac0dc8f9a72d924b"
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
    input = rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id":1,
      "method":"initialize",
      "params": {
        "rootUri": "file:devnull",
        "capabilities": {}
      }
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"initialized",
      "params": {}
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id": 1,
      "method":"shutdown",
      "params": null
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"exit",
      "params": {}
    }
    EOF

    output = Content-Length: \d+\r\n\r\n

    assert_match output, pipe_output(bin"rust-analyzer", input, 0)
  end
end