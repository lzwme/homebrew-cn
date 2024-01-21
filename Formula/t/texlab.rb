class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https:texlab.netlify.com"
  url "https:github.comlatex-lsptexlabarchiverefstagsv5.12.2.tar.gz"
  sha256 "679d72a73269addcd870d6742b418aed2fb7e256137f360e2cc80271f20f0704"
  license "GPL-3.0-only"
  head "https:github.comlatex-lsptexlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd1209ae19f2565129c8135b3422c294a0b8367c78e669d43b3d4f72985e50e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6c9581272f009038acd502662d3fcadbc0f93eb72c3a24265b31ecbddd6a24b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d79da4b00143f6f544e39ff2af9ec05d02ef065d1693fbbadc75dfe8bdbede0c"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ae6daf8a21c621880475ed7dbad5e430d4122866eceb857a1476611cc41f792"
    sha256 cellar: :any_skip_relocation, ventura:        "ee7ef43c08e06b1cfbab87fd57dcb116ab5dc50430dbdede6781f3be028272f6"
    sha256 cellar: :any_skip_relocation, monterey:       "3ffae0a12c9acca6a475c93cd1571c0802f47a9076862fbbf3f1937c503b58a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a698c5dad0cf7ca43286f9adc510412fd75a0e0b721b6ac783bb71d2ee8b19a7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestexlab")
  end

  def rpc(json)
    "Content-Length: #{json.size}\r\n\r\n#{json}"
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

    assert_match output, pipe_output("#{bin}texlab", input, 0)
  end
end