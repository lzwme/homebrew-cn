class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://ghfast.top/https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.12.11.tar.gz"
  sha256 "39f3c6be1fd24c5db7255714eccd67436ffbf4b95cdd400d3adc1cc987548729"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7e2acf9cdb401c5ec2e01ce9b1f3093b2d8510e2ce7ca3564cd9b5d61590f58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c636822d01970f45a40d2b8eacadfb2b235e7fc15eba929b73ae8b79d1a4a6de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f14abff0829a7ca1e3abb3258f9ab09c805d46c5423270f47570094e3cf5d86c"
    sha256 cellar: :any_skip_relocation, sonoma:        "166a5a0994436130e343165bf738d6f8528f23c33e11474c463dbfaa1fa7b746"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25ce00727b4dc5117b93420f8e7869e21f579e0ea1eac730308ed2414e94af57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79ba3a5c36d5266cabfc4ae215aafa125ea8286f2fbb5a364866eea8ab79351b"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    ENV["APP_VERSION"] = version.to_s

    system "cargo", "install", *std_cargo_args(path: "crates/forge_main")
  end

  test do
    # forgecode is a TUI application
    assert_match version.to_s, shell_output("#{bin}/forge banner 2>&1")
  end
end