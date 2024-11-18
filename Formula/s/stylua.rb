class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https:github.comJohnnyMorganzStyLua"
  url "https:github.comJohnnyMorganzStyLuaarchiverefstagsv2.0.0.tar.gz"
  sha256 "6222cb07ec22963cce2ff2cb0a64f8a5df59d9aa434191610948ad3607d668e0"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abd7ea3e53efa92a46309d7d26496ea09ca66517210f41b83d1b5ee55ed92ef8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7cf9816d2ae5194fb5b6c090fc29ee75239466134f7517ecc8fee78a0bbc43f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a7fa5f9995ae86b754acfa0dc13cdf642818496b6a0b7a30c6f8e89f3ecca81"
    sha256 cellar: :any_skip_relocation, sonoma:        "00cdbe48967e70796c9ab6a9f5075435a2fb89855add13329edd8252342d28c3"
    sha256 cellar: :any_skip_relocation, ventura:       "6f06c852fe2fadb5e598713b63dcf380029fffb20882c5b482c1e265a22be060"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f6368ebaaf54612dfa0b7cb65730a92a580f37b503faa97d7aa3f0280808e41"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args
  end

  test do
    (testpath"test.lua").write("local  foo  = {'bar'}")
    system bin"stylua", "test.lua"
    assert_equal "local foo = { \"bar\" }\n", (testpath"test.lua").read
  end
end