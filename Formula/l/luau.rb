class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags0.624.tar.gz"
  sha256 "6d5ce40a7dc0e17da51cc143d2ee1ab32727583c315938f5a69d13ef93ae574d"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3fd98ba62e8fd57c339c1e52cf0b55680d6d5987e19814d5ab62c9b01cdf7caa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a5f7b4db593f3253fe8b3c194d9720abf9b60d9518082f64037dd5d5a795c92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbe4ceceb4cbb31884bf2b240c5f1a6d93f70fcda23f45826e0bf4344c73469b"
    sha256 cellar: :any_skip_relocation, sonoma:         "844473fd604647a09d34de43b4924dd6bb1bf57c208d4f3ebd060246279b6518"
    sha256 cellar: :any_skip_relocation, ventura:        "539130ecae78020d6bc2faa18dee675578afc2526395ba8bbd5cf6de4c3b0334"
    sha256 cellar: :any_skip_relocation, monterey:       "d998247bfac13ba557c6d5261a25bf6bf3ac07758eab897a83ed810993fdf0e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09de8c1e2a98765e4131d447d4187e45efe37d87b64e3a4931973aa919aa9133"
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