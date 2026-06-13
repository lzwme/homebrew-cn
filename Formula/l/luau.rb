class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.725.tar.gz"
  sha256 "e51ead5f541633693d548057e0431927f3036c13b185fdb37fbc3f5a261e6676"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e678ad7c93654c94e108be2e8b8327e5ff5c7ab9444e059ee0e2c9450d55c8dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9748f9871388ee72262804a20db68a91d36bb8a371ff3365526e248d382835f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "609a8ece6e12d64fedbd3bc8649001fea77187b63384d2e742ad23c2dd78f152"
    sha256 cellar: :any_skip_relocation, sonoma:        "b287b3a0c4f2d5a8ed223d3191c37ce6700a5af526304224a0b9d700ebeb35ff"
    sha256 cellar: :any,                 arm64_linux:   "0f0e68549b9c6f8e837f87e33d88e8ff7509a7399edc4e4c7ecc42edd01398c3"
    sha256 cellar: :any,                 x86_64_linux:  "7bcb4aa1f12c41739c34d262be397958b8d1e9ccf80d5a7b8c4bbcc6b941d645"
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