class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.721.tar.gz"
  sha256 "b36924a114a76b4a48f02bcfbd14dfd0bb1c5b3a2f4bf246f254db50c031c061"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b2728400e4b043b5a35cc518d0f1e9aa21f06d11578a84e438491ba5adcaedc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2807813f4ecf91389f7b2dce455b797ab1aadc6f46406049277fb6b860e22ebc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e40e6f67838fc083f3705859eb17f9e4a848891b93edd6bedf5c30d507f305b"
    sha256 cellar: :any_skip_relocation, sonoma:        "17bfc895972cc63d8941fc39796d9fb985ebf62ad0a31b8194272cecea5acfb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bca9f286d71015725747810641f2ff7856350e1ea61d94ec0bbd252b7ad099b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4eed42f3807e272ca7f9414f55ef833d67a0799aa8b15b18274ca561111e5c88"
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