class Ffmpegthumbnailer < Formula
  desc "Create thumbnails for your video files"
  homepage "https://github.com/dirkvdb/ffmpegthumbnailer"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/dirkvdb/ffmpegthumbnailer.git", branch: "master"

  stable do
    url "https://ghfast.top/https://github.com/dirkvdb/ffmpegthumbnailer/archive/refs/tags/2.2.3.tar.gz"
    sha256 "8c9b9057c6cc8bce9d11701af224c8139c940f734c439a595525e073b09d19b8"

    # Backport support for FFmpeg 8
    patch do
      url "https://github.com/dirkvdb/ffmpegthumbnailer/commit/40e050673851baa59ca45c900e24d68027d9d675.patch?full_index=1"
      sha256 "595d57dac596e5b650cc68b78c1164a9b152ee80eb009929454d22198e59e1a5"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "8780d8815e15357e55cf6def6ba1793f43ac6e615d7925d1a1474d7c8756d436"
    sha256 cellar: :any,                 arm64_sequoia: "ab7919a1c1b869f076d8bea40fc316670c540dd1c5d5d0331a60b38a9ea16678"
    sha256 cellar: :any,                 arm64_sonoma:  "5e4aeb810cb0173fda235d57e7070c94891193151f860c7ef70a2899b4eb0bef"
    sha256 cellar: :any,                 sonoma:        "04890c1ddd1fd2c1725401f4eec72b4faf67d46bce812f69fcac390a73070018"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd8dbfa8b2c7676def8de9b5d76f6d7814edd140c7ba6e5fd2b88235aeec1ee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e4e92291ae6e0666bd28fc9908c5266d4364472a6a5ab15a42d2cc6a53a6483"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "jpeg-turbo"
  depends_on "libpng"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DENABLE_GIO=ON",
                    "-DENABLE_TESTS=OFF",
                    "-DENABLE_THUMBNAILER=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ffmpeg = Formula["ffmpeg"].opt_bin/"ffmpeg"
    png = test_fixtures("test.png")
    system ffmpeg.to_s, "-loop", "1", "-i", png.to_s, "-c:v", "libx264", "-t", "30",
                        "-pix_fmt", "yuv420p", "v.mp4"
    assert_path_exists testpath/"v.mp4", "Failed to generate source video!"
    system bin/"ffmpegthumbnailer", "-i", "v.mp4", "-o", "out.jpg"
    assert_path_exists testpath/"out.jpg", "Failed to create thumbnail!"
  end
end