class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https:github.comJohnnyMorganzStyLua"
  url "https:github.comJohnnyMorganzStyLuaarchiverefstagsv2.0.1.tar.gz"
  sha256 "ee0e70e38c8352e6534aac4394402a61ca8d8704e8c11403d9721536b517d66b"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd9ecd5d6b8fac1291adaf21f66cc41c0055f381b403a4246c7d622e6981305c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54209734a8c472f5d1743b55ab16bcc8035b7b72c9b34074554b71334e69a5af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54090a26083e1871d11ccd8deaef98f4f1c61ccafa42b6ad3c1237e76e2b23b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "71161d244b1d270e8e000836ad9759816e8011ff546c755f6cdcbe394000622d"
    sha256 cellar: :any_skip_relocation, ventura:       "c4b21ed79368d08f0d053b1fb3b7bb570fdc81d38187f3556134e43df529b74e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a5ccbac6daccb68e886ead569ad4ec5dffcdc9ea697908d1b1a662790162839"
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