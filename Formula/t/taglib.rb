class Taglib < Formula
  desc "Audio metadata library"
  homepage "https://taglib.org/"
  url "https://taglib.github.io/releases/taglib-2.1.1.tar.gz"
  sha256 "3716d31f7c83cbf17b67c8cf44dd82b2a2f17e6780472287a16823e70305ddba"
  license all_of: ["LGPL-2.1-only", "MPL-1.1"]
  revision 1
  head "https://github.com/taglib/taglib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1104d4550d75753c90fef5f64fbe61afe73a52a8909c68f86f32c83583e54dfe"
    sha256 cellar: :any,                 arm64_sequoia: "a2a37c1d46e2914e486aac6db04e5a002f39359eaecba7e31acef9b165301c4e"
    sha256 cellar: :any,                 arm64_sonoma:  "56b61a971bb3f45143768196600e48296af6da5eec28197aaffdb64a9306987a"
    sha256 cellar: :any,                 sonoma:        "05cc31b0d792a43d48dc5b19bb7167f4b559b3f28502c5808d4d5efb18798293"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39b0b35f4f92cab882f35af6fb70d82a26034235f40a9e8bbce5abc5d6349e34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f1c8b79bd81b63549f7ec5ff4bf226f02130c93ab95baeca6e613fed68959ca"
  end

  depends_on "cmake" => :build
  depends_on "utf8cpp"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %w[-DWITH_MP4=ON -DWITH_ASF=ON -DBUILD_SHARED_LIBS=ON]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <taglib/id3v2tag.h>
      #include <taglib/textidentificationframe.h>
      #include <iostream>

      int main() {
        TagLib::ID3v2::Tag tag;

        auto* artistFrame = new TagLib::ID3v2::TextIdentificationFrame("TPE1", TagLib::String::UTF8);
        artistFrame->setText("Test Artist");
        tag.addFrame(artistFrame);

        auto* titleFrame = new TagLib::ID3v2::TextIdentificationFrame("TIT2", TagLib::String::UTF8);
        titleFrame->setText("Test Title");
        tag.addFrame(titleFrame);

        std::cout << "Artist: " << tag.artist() << std::endl;
        std::cout << "Title: " << tag.title() << std::endl;

        return 0;
      }
    CPP

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-ltag"
    assert_match "Artist: Test Artist", shell_output("./test")

    assert_match version.to_s, shell_output("#{bin}/taglib-config --version")
  end
end