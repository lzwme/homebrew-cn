class Functionalplus < Formula
  desc "Functional Programming Library for C++"
  homepage "https://github.com/Dobiasd/FunctionalPlus"
  url "https://ghproxy.com/https://github.com/Dobiasd/FunctionalPlus/archive/v0.2.19-p0.tar.gz"
  version "0.2.19"
  sha256 "2e219250941b39aaab6299f3d3333614b8e661265ef012f64ccbc61aa6d74b93"
  license "BSL-1.0"
  head "https://github.com/Dobiasd/FunctionalPlus.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:[._-]p\d+)?)$/i)
    strategy :git do |tags, regex|
      # Omit `-p0` suffix but allow `-p1`, etc.
      tags.map { |tag| tag[regex, 1]&.sub(/[._-]p0/i, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8d8940d663021face917360b84a68f9ae83f230976cbb9495e8ef43b50a173ed"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <fplus/fplus.hpp>
      #include <iostream>
      int main() {
        std::list<std::string> things = {"same old", "same old"};
        if (fplus::all_the_same(things))
          std::cout << "All things being equal." << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cpp", "-I#{include}", "-o", "test"
    assert_match "All things being equal.", shell_output("./test")
  end
end