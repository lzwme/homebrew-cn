class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.703.tar.gz"
  sha256 "e661d85d03244cf6c00e5a17b493e19714b7b414b3bf8b9d1ae20b508ba2980f"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6af4d071e49622c5bfa45f67595936128c0487f533cf101f4dde7c5cf3a9d61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8d132534cb5552f0119c4762285f3544908d6a5b742e29d1d9683fed7b8dc6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abfd817b6fe0e9f6c23586fedea0f5535d870dc8b7823a6c49976b5ec23e4756"
    sha256 cellar: :any_skip_relocation, sonoma:        "7db9b9516910393beffbd030ac4bb0cd5b6ffed17f01b7098b6d37ddee546dc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46078651ebad7e29d506850448d2f5b412807c3568e376c1ce671ad6df1258c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9619bca603b7c6350baee4770d91e83065d81286604dbe4a1ec92332c6999c8"
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