class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https:github.comaous72OpenJPH"
  url "https:github.comaous72OpenJPHarchiverefstags0.14.2.tar.gz"
  sha256 "fbd5bc5b2e1961b467356412092c77ccb702c6ffa7a7d5f29262eed9f97c9119"
  license "BSD-2-Clause"
  head "https:github.comaous72OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bd3ef24ec8f7d77605e17d1c243196e6eb0590bb83329e32a764bbfc634c3c4b"
    sha256 cellar: :any,                 arm64_ventura:  "f2054e64aa37bf16533b54d127c9fe39ee1b846fb586bcde1b997190eff26f3d"
    sha256 cellar: :any,                 arm64_monterey: "91da514b5722639e57906ff1f1b7646d5f38a4b25b4791f19294de2932bc32ff"
    sha256 cellar: :any,                 sonoma:         "3b83dd2b077157ee01a9d24d9eeb787b57d32401d0254d42a7a6c15b93f9b630"
    sha256 cellar: :any,                 ventura:        "4b3733d6ac77e4d331b9509f948e20da1c1ae16dbf4d471001137fd3c244cfac"
    sha256 cellar: :any,                 monterey:       "4d7cc9031e6330935ae350471918b1188eca6232d177711e5282343a7a43dc68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67a5acc1b5906b8913ca6d18c3d75c4b5f72c2c05b2bbc1a836ea238cd1694a1"
  end

  depends_on "cmake" => :build
  depends_on "libtiff"

  def install
    ENV["DYLD_LIBRARY_PATH"] = lib.to_s

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-test.ppm" do
      url "https:raw.githubusercontent.comaous72jp2k_test_codestreamsca2d370openjphreferencesMalamute.ppm"
      sha256 "e4e36966d68a473a7f5f5719d9e41c8061f2d817f70a7de1c78d7e510a6391ff"
    end
    resource("homebrew-test.ppm").stage testpath

    system bin"ojph_compress", "-i", "Malamute.ppm", "-o", "homebrew.j2c"
    system bin"ojph_expand", "-i", "homebrew.j2c", "-o", "homebrew.ppm"
    assert_predicate testpath"homebrew.ppm", :exist?
  end
end