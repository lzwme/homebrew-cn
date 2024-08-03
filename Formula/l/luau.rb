class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags0.637.tar.gz"
  sha256 "72c59c818ef15b7a19e60c18456a92112dbc88d4c3059152419ca343aea335ae"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c76560420b43138b62cf6476d4267f6a69079d6ea4946b11a0988b6705d02b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34c02fb91717e94f92bb85078d7bfa6d0dd449312210584c91de16e300f3539a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c66edeffc321fcdb582799c3b219ca696f8ce485aa83181bc032645899b8c25"
    sha256 cellar: :any_skip_relocation, sonoma:         "10c976da25639164e402b9eb1e9dfe5547a0f11bfe1d21a86623e3abb8df42d0"
    sha256 cellar: :any_skip_relocation, ventura:        "460197dcf8c01fc8fd0e1d58205132d323018e616e8e4c6267507f03ecaa1a90"
    sha256 cellar: :any_skip_relocation, monterey:       "2d2dd847a95ca41f7ec39b5cb0f7eff2c38da744b1d4a5e0e4370ce2e2cd87af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "390cd41a1809f1f6ea8bfcb9a371f429fab3d8182b4e8f956d44a9f47b242dec"
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