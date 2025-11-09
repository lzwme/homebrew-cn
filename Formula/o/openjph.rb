class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://ghfast.top/https://github.com/aous72/OpenJPH/archive/refs/tags/0.25.2.tar.gz"
  sha256 "ae5f09562cb811cb2fb881c5eb74583e18db941848cfa3c35787e2580f3defc6"
  license "BSD-2-Clause"
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ed6b535c8d5c3a6e6d8f5b1b4088ca6ddb3f1f1cdf9bdb429e51efb12251114b"
    sha256 cellar: :any,                 arm64_sequoia: "0779ae68deaad2081ef9dbf83cc97ce23add21de02e01780425a177c25f087f4"
    sha256 cellar: :any,                 arm64_sonoma:  "6858c50a76c2730dc0a1d8f9f4dd8ad2cc30d9c4362f1b065c15861af5927b0d"
    sha256 cellar: :any,                 sonoma:        "826c73c73859736ebe0c7610335f9fa8c0b76dda5ba4d0678adef9dbb080538f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9367c8459284cff73b76339c0519997c2d18e6338e90126e82b8295a03699666"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7f62a0585f56a412b4849e1756894ca989f7147868d611d1d9f3dbbd2140040"
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
      url "https://ghfast.top/https://raw.githubusercontent.com/aous72/jp2k_test_codestreams/ca2d370/openjph/references/Malamute.ppm"
      sha256 "e4e36966d68a473a7f5f5719d9e41c8061f2d817f70a7de1c78d7e510a6391ff"
    end
    resource("homebrew-test.ppm").stage testpath

    system bin/"ojph_compress", "-i", "Malamute.ppm", "-o", "homebrew.j2c"
    system bin/"ojph_expand", "-i", "homebrew.j2c", "-o", "homebrew.ppm"
    assert_path_exists testpath/"homebrew.ppm"
  end
end