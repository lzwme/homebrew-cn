class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https:github.comJohnnyMorganzStyLua"
  url "https:github.comJohnnyMorganzStyLuaarchiverefstagsv0.19.1.tar.gz"
  sha256 "c232227bf6085e3039b47a2ee24c76dad6ba1e786df65d9933ee000a3ee2c36e"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c809b1dcd2a9ecb0574c94b7b63e3822ac222a27790cb94359ff6807e256441c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79f8d9d627d0860288dab006255c401433dbdfb2e7105efaea46e6fad338ad19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9ecd2f73ab645f2b76486f799f5493dccca143f61cfda4b324e30e381ed5c1c"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a3a5526b3be39343aae96b6a05d6989a850010bc8c6e0e26ca0d826d52f5b14"
    sha256 cellar: :any_skip_relocation, ventura:        "1dbba01f5ac63aa03e88a7d5a54709acd5def44ac219d965c999b81d3c154a1c"
    sha256 cellar: :any_skip_relocation, monterey:       "39bd78f041dabc0ecf2e15909197d1ab16cacd010d06f81bc427cb6045813a30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a613a74551a2f297e0cbe5aaaca827335c1ab0f5874544e66ea0533a45b6bd1"
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