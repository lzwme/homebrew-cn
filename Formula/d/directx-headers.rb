class DirectxHeaders < Formula
  desc "Official DirectX headers available under an open source license"
  homepage "https://devblogs.microsoft.com/directx/"
  url "https://ghfast.top/https://github.com/microsoft/DirectX-Headers/archive/refs/tags/v1.619.0.tar.gz"
  sha256 "e1bfbe81c3eb2654abd4ac9642af2e78bd1c65c5868bf9699953af205625bca9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "323c8e0d951d3e38e11b2c5c707782638a27a92e3ea79d937132cce8793e5746"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5b9747cbbf42996f3c2290e3c05023da894a4ee20c6c3cca49dd24cd20900a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b711f9c7ee11e603d19272cb1524aa8b4d1210718551c89da605907f73d0948e"
    sha256 cellar: :any_skip_relocation, sonoma:        "34292497b21cc03f351c04131ef69ed2e4328aaf5c6a5ab753f13b3570476c23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b45612ea58ba1b8be4d74f656818dce40ab935c71d73ecd1e148ba9037ba8cd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56e31b6f9a74a21ee3df6d7330be32ae9c621906a7553833102f563c471cd3e9"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "mingw-w64" => :test

  def install
    system "meson", "setup", "build", "-Dbuild-test=false", *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    resource "test.cpp" do
      url "https://ghfast.top/https://raw.githubusercontent.com/microsoft/DirectX-Headers/a7d19030b872967c4224607c454273a2e65a5ed4/test/test.cpp"
      sha256 "6ff077a364a5f0f96b675d21aa8f053711fbef75bfdb193b44cc10b8475e2294"
    end

    resource("test.cpp").stage(testpath)

    ENV.remove_macosxsdk if OS.mac?

    system Formula["mingw-w64"].bin/"x86_64-w64-mingw32-g++", "-I#{include}", "-c", "test.cpp"
  end
end