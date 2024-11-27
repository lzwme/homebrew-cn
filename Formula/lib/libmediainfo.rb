class Libmediainfo < Formula
  desc "Shared library for mediainfo"
  homepage "https:mediaarea.netenMediaInfo"
  url "https:mediaarea.netdownloadsourcelibmediainfo24.11libmediainfo_24.11.tar.xz"
  sha256 "96e44a617f90c8b63bb685ad53be6716b7df4221793c329780f02aea6e707aa1"
  license "BSD-2-Clause"
  head "https:github.comMediaAreaMediaInfoLib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3427787833fe8c033078515e1ea8353eaab13e005941fd27eb6a85f85e9b5378"
    sha256 cellar: :any,                 arm64_sonoma:  "85d5d24c152d76b6a05535b3ae22c5a0d88d8e17b81a347f2e5ef60e0c27a515"
    sha256 cellar: :any,                 arm64_ventura: "38cb6ae2a91bbd88764cf647afa1ac2276d0b22e0644168486257e57756011dd"
    sha256 cellar: :any,                 sonoma:        "d827fc809e651c6ac2719729a5cdbf26a837423a0ec27fab55b2eacfe7d74cd9"
    sha256 cellar: :any,                 ventura:       "131a65274d572de55ce52e9cb01882f30a8abd778544995579f45942b0c477bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "942d09d98a3ef3146243709d5109c2aa63d27ac42fca5f9c43fa1dd2c29b2ff2"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "libmms"
  depends_on "libzen"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  # These files used to be distributed as part of the media-info formula
  link_overwrite "includeMediaInfo*"
  link_overwrite "includeMediaInfoDLL*"
  link_overwrite "libpkgconfiglibmediainfo.pc"
  link_overwrite "liblibmediainfo.*"

  def install
    system "cmake", "-S", "ProjectCMake", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cc").write <<~CPP
      #define _UNICODE
      #include <iostream>
      #include <string>
      #include <filesystem>
      #include <MediaInfoMediaInfo.h>

      int main(int argc, char* argv[]) {
          std::wstring file_path = std::filesystem::path(argv[1]).wstring();

          MediaInfoLib::MediaInfo media_info;
          size_t open_result = media_info.Open(file_path);
          std::wstring result;

           Get information about audio streams.
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
    system ".test", test_fixtures("test.m4a")
  end
end