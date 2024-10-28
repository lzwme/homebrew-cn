class Libhubbub < Formula
  desc "HTML parser library"
  homepage "https://www.netsurf-browser.org/projects/hubbub/"
  url "https://download.netsurf-browser.org/libs/releases/libhubbub-0.3.8-src.tar.gz"
  sha256 "8ac1e6f5f3d48c05141d59391719534290c59cd029efc249eb4fdbac102cd5a5"
  license "MIT"
  head "https://git.netsurf-browser.org/libhubbub.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "508f0ebd9f00da4d05a4d477c55c9cae35ecd8b2b80ae83871623ae11c67ef9b"
    sha256 cellar: :any,                 arm64_sonoma:  "e024f9c815850423b7eed9a0cb5c9d3f0a83e980f6a5aced31b006c9f43fd6f8"
    sha256 cellar: :any,                 arm64_ventura: "81e8aa3aae89f339efbf14d216270d1c57729e525b20c7d977dfa539f71012b0"
    sha256 cellar: :any,                 sonoma:        "015c9012d635556347bf3a0e1f5d003b81a5834f2a91c717ebe9929e5fd8a232"
    sha256 cellar: :any,                 ventura:       "0544ada9a05f3db96da5338b41f0251e265fb784b1109ec0e688ffeb942f568b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1156a785370dd503db4817f034028986f1c6eea21d79c0c59a2a66f6ca07391c"
  end

  depends_on "netsurf-buildsystem" => :build
  depends_on "pkg-config" => :build
  depends_on "libparserutils"

  uses_from_macos "gperf" => :build

  def install
    args = %W[
      NSSHARED=#{Formula["netsurf-buildsystem"].opt_pkgshare}
      PREFIX=#{prefix}
    ]

    system "make", "install", "COMPONENT_TYPE=lib-shared", *args
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <hubbub/parser.h>

      int main() {
          hubbub_parser *parser;
          hubbub_error error;

          error = hubbub_parser_create("UTF-8", false, &parser);
          if (error != HUBBUB_OK) {
              return 1;
          }

          hubbub_parser_destroy(parser);
          return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lhubbub"
    system "./test"
  end
end