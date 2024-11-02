class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags0.650.tar.gz"
  sha256 "a605ae7a188455844ab131ff0d2df6f38c088142d6bd5eebb87795e619c3d7aa"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63d287bc80755391a2b45ca73458c1ae0982b57c09c6c518fc51f90e9eeba81b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1025aaa1b1f06bcea573af7466f0701ad0013a76622fef21307dfab05dd7d5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "20b21c998e0594f8660592adb80e6ba07b4c9717a61f36556d731576d818d2cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "e71d64e2e6b55cc61d5395ab02ab5dab766943b9c3554c337b73b5ad12a018fc"
    sha256 cellar: :any_skip_relocation, ventura:       "09bed04175d5fa0af20d36c5ecf4e19821033e62df78d3c02360eb541dc9f35c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fb1af41be54d762f794b10f1799e1ec277f2d41f7bb1ecd841d5af2568fa8a7"
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