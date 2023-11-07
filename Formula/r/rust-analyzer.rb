class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-11-06",
       revision: "c1c9e10f72ffd2e829d20ff1439ff49c2e121731"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48b753e4649da33dc37afd4c0f7062f00a2622003d87bb0187446d846fa7553e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2600dc8cf44dba01de2b00b46162d0425a75a06f439940b6812d0357d54aa832"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1dab32737b457cd8f390cabb70a000525b738544261bf0f8e9f311546cde92e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f4a1dd997480dbcb58864753d74531e2cad27837355427e9c9f6a8db3d1011b7"
    sha256 cellar: :any_skip_relocation, ventura:        "cddcddf03b9847c0516d25053da17a54264535a9c0076aa4aa228d5f0e7712b4"
    sha256 cellar: :any_skip_relocation, monterey:       "8c2c12770ee6dc78f983e262627639523bd46e5cc8ef5b60cafbf1939aa6c5d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "709cc18eb079f230f93fa030485911eedcc87e4b491ace09ab94aff087c40287"
  end

  depends_on "rust" => :build

  def install
    cd "crates/rust-analyzer" do
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
        "rootUri": "file:/dev/null",
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

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output("#{bin}/rust-analyzer", input, 0)
  end
end