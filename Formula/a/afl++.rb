class Aflxx < Formula
  desc "American Fuzzy Lop++"
  homepage "https:aflplus.plus"
  url "https:github.comAFLplusplusAFLplusplusarchiverefstagsv4.21c.tar.gz"
  sha256 "11f7c77d37cff6e7f65ac7cc55bab7901e0c6208e845a38764394d04ed567b30"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sequoia: "9890de4f599763850e2cdb9d9037fa34cc7c04d08c1f916234b72a0c7d2eb7f3"
    sha256 arm64_sonoma:  "7745329b39fe8415d4fc618d8ede5c767a68aa2c9d32f395c7abfe5e23bea693"
    sha256 arm64_ventura: "4e25af8d57958d19dcf5b28aa1c37dbc3c7a288537def8840dcfa991b3a498e7"
    sha256 sonoma:        "06de9fe419ff08963a9be3ac77e811902f5b4b8b33fc7a64a1252f869514d541"
    sha256 ventura:       "a9e9a292f9ce850c3a189f032a9327543306ebe5d74559733c4f516cae127053"
    sha256 x86_64_linux:  "d16aec76ab8a4dbbc2c98f316b56612a464993f87f87076056e1371f4e41c9c4"
  end

  depends_on "coreutils" => :build
  depends_on "llvm"
  depends_on "python@3.12"

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec"gnubin"

    inreplace "GNUmakefile.llvm" do |s|
      s.gsub! "-Wl,-flat_namespace", ""
      s.gsub! "-undefined,suppress", "-undefined,dynamic_lookup"
    end

    if OS.mac?
      # Disable the in-build test runs as they require modifying system settings as root.
      inreplace ["GNUmakefile", "GNUmakefile.llvm"] do |f|
        f.gsub! "all_done: test_build", "all_done:"
        f.gsub! " test_build all_done", " all_done"
      end
    end

    system "make", "source-only", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    cpp_file = testpath"main.cpp"
    cpp_file.write <<~EOS
      #include <iostream>

      int main() {
        std::cout << "Hello, world!";
      }
    EOS

    system bin"afl-c++", "-g", cpp_file, "-o", "test"
    assert_equal "Hello, world!", shell_output(".test")
  end
end