class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau.org"
  url "https:github.comluau-langluauarchiverefstags0.662.tar.gz"
  sha256 "099738bb64daea1ccc99bbe670711356bc3f93ff8bd6da12e0e71aad27e66ace"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e906707d357984bc1879ae766396bdb8561059840857a3f57ff82f5109963b1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0726a89a3f9bd3123cbd739ccf25e563ce981a8c1ecc48e55d99050f9c37b95f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d737e9a3a19c617390143d71945de01073c4af8cc5347fc600cc9daf34801c0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cbd981b9553b9affaa9befdb175309562dfac35a7ec14caf91807f9658966bc"
    sha256 cellar: :any_skip_relocation, ventura:       "af07e34ac865affe63a3bcac1f5f6e3681400d4f0f498d70a049c0060748062c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41b1d4df2f32f4e7b46de8cefba20eb58903835b70f9770a81174ef982265063"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLUAU_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install %w[
      buildluau
      buildluau-analyze
      buildluau-ast
      buildluau-compile
      buildluau-reduce
    ]
  end

  test do
    (testpath"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}luau test.lua")
  end
end