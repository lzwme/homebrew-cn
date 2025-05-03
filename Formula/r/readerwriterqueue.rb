class Readerwriterqueue < Formula
  desc "Fast single-producer, single-consumer lock-free queue for C++"
  homepage "https:github.comcameron314readerwriterqueue"
  url "https:github.comcameron314readerwriterqueuearchiverefstagsv1.0.7.tar.gz"
  sha256 "532224ed052bcd5f4c6be0ed9bb2b8c88dfe7e26e3eb4dd9335303b059df6691"
  license all_of: ["BSD-2-Clause", "Zlib"]

  bottle do
    sha256 cellar: :any_skip_relocation, all: "907ae19ab677f362e0f4e54395b94da1703ef246bcc6083787fd4de3f0fb33a2"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <cassert>
      #include <iostream>
      #include <readerwriterqueuereaderwriterqueue.h>

      using namespace moodycamel;

      int main() {
        ReaderWriterQueue<int> q(100);
        q.enqueue(17);
        bool succeeded = q.try_enqueue(18);
        assert(succeeded);

        int number;
        succeeded = q.try_dequeue(number);
        assert(succeeded && number == 17);

        int* front = q.peek();
        assert(*front == 18);
        succeeded = q.try_dequeue(number);
        assert(succeeded && number == 18);
        front = q.peek();
        assert(front == nullptr);

        std::cout << "OK" << std::endl;
      }
    EOS

    system ENV.cxx, "-I#{include}", "test.cpp", "-o", "test"
    assert_equal "OK\n", shell_output(testpath"test")
  end
end