class Libmediainfo < Formula
  desc "Shared library for mediainfo"
  homepage "https:mediaarea.netenMediaInfo"
  url "https:mediaarea.netdownloadsourcelibmediainfo24.03libmediainfo_24.03.tar.xz"
  sha256 "cc2bb44e407c890ab566934c56763918505ab58c14134b53f0d1da9eea242c8d"
  license "BSD-2-Clause"
  head "https:github.comMediaAreaMediaInfoLib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "20cce2d764164d8dd5933d59bd7972dc391fef8ed8c59888b0b52d40eeeeb06a"
    sha256 cellar: :any,                 arm64_ventura:  "2ddfb455dc2da4eb1c889229bd5c041dc8e8560adb83257735d07f2756d828e7"
    sha256 cellar: :any,                 arm64_monterey: "6ffe22aae0fbf1c320d343eef6a70ce03632baf8f292e51fd9b08c2a3338e24e"
    sha256 cellar: :any,                 sonoma:         "82b8bc5dd22067069e5e4d4d7460307c9e9e77b4fa7a7135e851bfded144e1e4"
    sha256 cellar: :any,                 ventura:        "6414540a3435628255b7b9678696b7f9ce509244d66ff51d069b9674d57bb348"
    sha256 cellar: :any,                 monterey:       "e594ad76d0b24a7a8a456c3e33aa0a3b0686d3eab0f819fc574a2aee8d18b113"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2489f55bbf696389ca917282bf689b0416b24052f22996f4e647df3f718bc5c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libmms"
  depends_on "libzen"

  uses_from_macos "curl"

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
    (testpath"test.cc").write <<~EOS
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
    EOS
    system ENV.cxx, "-std=c++17", "test.cc", "-I#{include}", "-L#{lib}", "-lmediainfo", "-o", "test"
    system ".test", test_fixtures("test.m4a")
  end
end