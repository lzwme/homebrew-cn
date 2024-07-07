class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https:github.comlatex-lsptexlab"
  url "https:github.comlatex-lsptexlabarchiverefstagsv5.18.0.tar.gz"
  sha256 "e1e71b41d134a2cbac0aa2ca27e1125a0609373394b044e9301d83b94b390216"
  license "GPL-3.0-only"
  head "https:github.comlatex-lsptexlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b01c08bee298180e0aec6637420275fdce883ffcabfcf9c30948f9bf11025e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7f57957196897136f0e1e07849b9fda1052cb99e37e02f32f516d26e69295ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77e06aa1bd6746c7978dac726232fac0075460176b9c9f08970dfeb1e5c540a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9b0ce1c1b85191b6548d919bd18026e16468c1ab40b46aa8fdbb55769b55c85"
    sha256 cellar: :any_skip_relocation, ventura:        "60122cd6fcf26a3c1afa94cfe8a48cc3f24ff5dd7c291a17407a254c5a17a7c4"
    sha256 cellar: :any_skip_relocation, monterey:       "d811ef6cc1ed200b9a4db199f1f9db7e92db16e4bb9d8d99ff7fc31e3d2f3215"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e1ecfe2f32a9fab4507bfb2618d6beeeac9d2fabed02d972bf675cf114c5ace"
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