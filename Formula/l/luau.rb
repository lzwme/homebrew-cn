class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau.org"
  url "https:github.comluau-langluauarchiverefstags0.663.tar.gz"
  sha256 "711bd5a18e4ae20fffd7394da669d7fc232626bb713a52936acc9f478620d84d"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a737af54eda5e7f70a9b762d9cdd0817be7f61c873188aab15881f23c8f92c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3659a0d894cd23b83633c0e0c0f7d3cb04c0abdab37d08bc0528f5dbe80832c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9252dc8370b9ad2bed3aed129e1ff11feb37134e20559044294cc5b3eb9d956"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ac29c92371edf4003debd48872e247d63ea174580b431a52ed856aee7ff88f4"
    sha256 cellar: :any_skip_relocation, ventura:       "a0ad25e84369df268397c1cdea488ce93e2ff602748366ff53de90f8f3e9da49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bacc0df234c09e03f47fb120462180226535f32abdcd3f840110548fdb5f12dd"
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