class Libmediainfo < Formula
  desc "Shared library for mediainfo"
  homepage "https:mediaarea.netenMediaInfo"
  url "https:mediaarea.netdownloadsourcelibmediainfo23.11libmediainfo_23.11.tar.xz"
  sha256 "197e54fcc79e3c0d5df44a8f58dc4e018bc2f85d13fa3bed54af3dc56d5e853d"
  license "BSD-2-Clause"
  head "https:github.comMediaAreaMediaInfoLib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cab0ead4f0bee75ba109f023e6d2e6c5f2fc129cc07025498fcbf5f10e835167"
    sha256 cellar: :any,                 arm64_ventura:  "f29bc88befaee67c09658fbe21705e9fe2d592654d68f17200e451c7e1e23956"
    sha256 cellar: :any,                 arm64_monterey: "674a96983ddb1b05c86e4c6ae6ae05623c6ee2832a1b6111f0fad2f8db275895"
    sha256 cellar: :any,                 sonoma:         "6d003a873f480d42441d737ffdb3596303c9c5ef132621597a4604cd84721e46"
    sha256 cellar: :any,                 ventura:        "4080c615c3f0f75abeaaabd498506bc7a6ccbd52bb028b6590381d36d5b98808"
    sha256 cellar: :any,                 monterey:       "4610fd4e34a57339feac57accac3ffa3e0dbd56356045d84a3ceb16680803bf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83fbb17ceba050fac8042b2a5dc8ab84db2eb92a40a0575ad3c0221f090ed7c3"
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