class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags0.636.tar.gz"
  sha256 "b5ff67f87c6b00e122d62feaa7a243b9f0dc97ca1cb47f97e9c92e58e860cbb4"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e60d390fc26d732687338d6245da18e97097530bc3a2a80ab6ce4a9b8088445"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f785094153e9e3e8c75e237132ad2409b1db55025819593cebe9b7042f7eceb8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd1b99c32a8d0f39086b19d02f64510544284d91af4a8e90805a3a7282241b27"
    sha256 cellar: :any_skip_relocation, sonoma:         "00c915de7dba097be5e7ab81c0aedb5c623995e14267abb91d122a43aa771e4a"
    sha256 cellar: :any_skip_relocation, ventura:        "929d372f4cdac01ecca2ab19df396bee05800d8a11956c53698c3c1d1afcde51"
    sha256 cellar: :any_skip_relocation, monterey:       "a9750f472d0d59b1e046efb1df1e3ca62ef50661628b0def006df2cacf6f991a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a14ad6a771407cfab05cc61e70ae606dea60f126766e1582d305df63847b459f"
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