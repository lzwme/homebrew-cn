class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.733.tar.gz"
  sha256 "097b63982a743b430583bf5b9194acd1566d6fa096a78919b0391a6d1300b85e"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdf4119f913b9a82c3731e4c1ec9a0a9dcbd8bc5d19371ba0823d1cec2a70d6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44e1d35c52e52021abb77a6bb673a2a04370e9507bfb08a6b846f838d167ae93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de32cf89ca30bc13d638cfaefc03f60d23cd7780773549ce9295e96ca9bccb77"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9639a4ac65517864a3675e84331d64f130b264addbc1205ee12d75540adc406"
    sha256 cellar: :any,                 arm64_linux:   "83b804d8f568f18938edefeee32227afb487c4383630cd206b5def1d0e13ba4e"
    sha256 cellar: :any,                 x86_64_linux:  "08632b7439c602b42be44ac1f193f3d19bc662dfaf3ef02e6eb139932cff88ca"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLUAU_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install %w[
      build/luau
      build/luau-analyze
      build/luau-ast
      build/luau-compile
      build/luau-reduce
    ]
  end

  test do
    (testpath/"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}/luau test.lua")
  end
end