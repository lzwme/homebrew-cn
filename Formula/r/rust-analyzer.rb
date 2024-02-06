class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-02-05",
       revision: "39ad79bec5202fda903893034918cb5526bb834c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5209a214f656a42b1ec6a73e4377730eebfbb561217528815893895c03c27801"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2d090c49d00a8bc193adf843202c4da169ececa46a2081e6cd8e0ef43db4c0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9db14e30f4103a0879f9b2cb09877405b7ad6da0aecf785237804957b62853ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "9cb0653676732f6ea9eb48663e1adbb88178a78350255beb2fc4a101b9dd69db"
    sha256 cellar: :any_skip_relocation, ventura:        "a6476a14cb1a41030d65072dc3986266c104330c9edebf15534ee86bafe57247"
    sha256 cellar: :any_skip_relocation, monterey:       "70e8511dd05d9c63500adf1a5804019d7dd9ca6ed3e5f175c3a6acbb44188758"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3226734e324287f9623be8bbd601e724ab20cab7b8a617ea314369955fee1317"
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

    assert_match output, pipe_output("#{bin}rust-analyzer", input, 0)
  end
end