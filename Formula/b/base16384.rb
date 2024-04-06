class Base16384 < Formula
  desc "Encode binary files to printable utf16be"
  homepage "https:github.comfumiamabase16384"
  url "https:github.comfumiamabase16384archiverefstagsv2.3.0.tar.gz"
  sha256 "b3cda811eabd002cc16f5c0a3fdcac7bf4ffbdeb1447139e6fd21de4811e2f76"
  license "GPL-3.0-or-later"
  head "https:github.comfumiamabase16384.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1425e172ab1f8b97b5317e176b7b362edaa3b8a996c3bb9c5d427ecaf8d97879"
    sha256 cellar: :any,                 arm64_ventura:  "3b93a7f479c0e2b65e652f1f81c8a1f13bd93df1da1c38103a5f326fa40dcb27"
    sha256 cellar: :any,                 arm64_monterey: "b903f1ddd6a7b781ed97ca0c6ad3ec56324e929c699291795b17f5b28214db21"
    sha256 cellar: :any,                 sonoma:         "7ebe446dc13a9bb2df77b3e0f8fa5530b038c0e5583b1289cd28d7877a313915"
    sha256 cellar: :any,                 ventura:        "8a5f75fffc8125d36329e7d384cddff38316a5e45186cb8864c6debd20b909f0"
    sha256 cellar: :any,                 monterey:       "996ebae6a09cb75a31a2fa72f96d6908fdc0458542c6b37e074ae54a79f759f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3eaaea4796873ffc38bffe01491f26e33110accf9e1b5e7bffe967aa5cd9fd38"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    hash = pipe_output("#{bin}base16384 -e - -", "1234567890abcdefg")
    assert_match "1234567890abcdefg", pipe_output("#{bin}base16384 -d - -", hash)
  end
end