class Libmediainfo < Formula
  desc "Shared library for mediainfo"
  homepage "https://mediaarea.net/en/MediaInfo"
  url "https://mediaarea.net/download/source/libmediainfo/26.01/libmediainfo_26.01.tar.xz"
  sha256 "bcd3d2cc12cf108ca0fbad07568b303257e72afd8ff73d05cfe6b7aa0e66a1c5"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfoLib.git", branch: "master"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?libmediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "057ea07e04e096e4108fb0b6c388dd59c7e1b038d893295f8e088566a6b6130b"
    sha256 cellar: :any,                 arm64_sequoia: "d5c25421c7fddb3ff33cecfa11ab1da6e25ca008f5919b492ee3c2bf475318bb"
    sha256 cellar: :any,                 arm64_sonoma:  "19a2c387f736d9549f2819ebef5ea8cf596a02f3db476c90e42417cd329009e7"
    sha256 cellar: :any,                 sonoma:        "d60d3689ffbf0827baa17c349bc6d8662b6c0400d7026f84d5a8bf132a3348e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce1099b019a5536607362cdd11ee626bfa3c45edd7ae06f55526fd31e32e5179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "100b7c3a9aa168f1e64f1cd647a079be46f1906f2cf2bf9bc53ec7e039d2455c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "libmms"
  depends_on "libzen"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  # These files used to be distributed as part of the media-info formula
  link_overwrite "include/MediaInfo/*"
  link_overwrite "include/MediaInfoDLL/*"
  link_overwrite "lib/pkgconfig/libmediainfo.pc"
  link_overwrite "lib/libmediainfo.*"

  def install
    system "cmake", "-S", "Project/CMake", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #define _UNICODE
      #include <iostream>
      #include <string>
      #include <filesystem>
      #include <MediaInfo/MediaInfo.h>

      int main(int argc, char* argv[]) {
          std::wstring file_path = std::filesystem::path(argv[1]).wstring();

          MediaInfoLib::MediaInfo media_info;
          size_t open_result = media_info.Open(file_path);
          std::wstring result;

          // Get information about audio streams.
          size_t audio_streams = media_info.Count_Get(MediaInfoLib::stream_t::Stream_Audio);
          for (size_t i = 0; i < audio_streams; ++i) {
              result = media_info.Get(MediaInfoLib::stream_t::Stream_Audio, i, L"Format");
              if (result == L"AAC") {
                  std::cout << "The file contains an audio stream in the m4a (AAC) format." << "\\n";
                  media_info.Close();
                  return 0;
              }
          }

          media_info.Close();
          return 1;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cc", "-I#{include}", "-L#{lib}", "-lmediainfo", "-o", "test"
    system "./test", test_fixtures("test.m4a")
  end
end