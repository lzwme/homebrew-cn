class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags0.631.tar.gz"
  sha256 "485caec5a013315eee831edeb76f751fa57440046c05195674b18110f25694c4"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f77a8c076f479fed02b7ec573503ed6b31955e11e2f86c829a7de0775cb3257b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e98f3e4641c191f7302f21a772beda62bb655c06e8a6eff83157ac52800cb94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b28bf9b6314de3af3f16428e147036fa0fd013db46d5c0be00c89461f3db9e73"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd6c336507356fa362ba4267e4bc23633a497b6183ab57db07e31701bbc1f1b1"
    sha256 cellar: :any_skip_relocation, ventura:        "0b09b2e743fe73ad08359c1c92b954aa8ff530bd957db6bc0b01b3807e067fd0"
    sha256 cellar: :any_skip_relocation, monterey:       "07e4af963c44a5dd00c01952e4388080c06f4850d34807a5754d7870af9fab90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b81d1fd719748f36827c255ebf5012094fcd04c239d75d8da119cb49e10d234f"
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