class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags608.tar.gz"
  sha256 "733853308a24b12058d1a9ad273745d512c59b444bb43dc2c43f498c01ea1a73"
  license "MIT"
  head "https:github.comluau-langluau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "107e0856599983499ca72070d42ce5d704524d609f00fa5afe036c2516d40eb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0f60e92b4f6f37c95fc3700b6b7234919dcf78c96d280168887247a60487f1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8222b65aa1f58858037ab8312206144f9e3666a668d0de6f2d97bde4c7a57c42"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0b8900ab615c28f47a0202cca8e5f57844da3df9e5f171bc826f75719d2e48e"
    sha256 cellar: :any_skip_relocation, ventura:        "bb70a9e5a0e993f057f4e57a2081911ee18226f31a267b0ab062a87881f5504f"
    sha256 cellar: :any_skip_relocation, monterey:       "16b832a3acc2fea4405d215d49a5f80e327b9d8b0fe4766b624240cac182b6b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d59c25c631e3f8a771503cd49685c24e9b5a257295bfeb177ce38e489c1aee0"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

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