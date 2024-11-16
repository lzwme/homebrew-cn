class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags0.652.tar.gz"
  sha256 "56c904c5ea25e537bdc8675ed52f5f0b56eb3d6e960fb9f93b8443229076f518"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "191c580b4a439ac24c096c595e7b16f6ad3b58c59bb8e6339afe8abd34e0504c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1487b8da1e43eeb2f6ba64104f566c003508fea6987bd3323070f47d7cab8885"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "238dde2ac20914bef6277647287b93ed13bfef3479189763741d14631d5006f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f69992483d33ef841be159d4a5975748b70855f9f4e6fbf02b8bc8faf8b2cf7"
    sha256 cellar: :any_skip_relocation, ventura:       "c839557513fc456e444174f23951b0bf72b650aa63ed3ce6e90b4e48b4922172"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93fdbf1b8492a63cfd64ffab24cb84cae416d7116bc44624342043e42589a956"
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