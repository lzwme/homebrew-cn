class AtomicQueue < Formula
  desc "C++14 lock-free queues"
  homepage "https://github.com/max0x7ba/atomic_queue"
  url "https://ghfast.top/https://github.com/max0x7ba/atomic_queue/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "7f0004b3821f90e35d898d37564be273909aeb24a8ca71a988fc65a5cf584a68"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f681184249ba27a8a9c298e8ecdf3157daca2ad2a1fc31453d549280be0bb2f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f681184249ba27a8a9c298e8ecdf3157daca2ad2a1fc31453d549280be0bb2f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f681184249ba27a8a9c298e8ecdf3157daca2ad2a1fc31453d549280be0bb2f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f681184249ba27a8a9c298e8ecdf3157daca2ad2a1fc31453d549280be0bb2f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "562c80d06a8218b27a4ce6f0fc41bf701e92a6c953f3854a01b0fabc28391cb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "562c80d06a8218b27a4ce6f0fc41bf701e92a6c953f3854a01b0fabc28391cb9"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  def install
    system "meson", "setup", "build", "-Dtests=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <cassert>
      #include <memory>
      #include <atomic_queue/atomic_queue.h>

      int main() {
          using QueueT = atomic_queue::AtomicQueueB2<int, std::allocator<int>, true, true, true>;
          auto queue = QueueT(64);
          queue.push(5);
          assert(queue.was_size() == 1);
          assert(queue.pop() == 5);
          return 0;
      }
    CPP

    flags = shell_output("pkgconf --cflags --libs atomic_queue").chomp.split
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++14", *flags
    system "./test"
  end
end