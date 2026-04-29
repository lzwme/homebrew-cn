class AtomicQueue < Formula
  desc "C++14 lock-free queues"
  homepage "https://github.com/max0x7ba/atomic_queue"
  url "https://ghfast.top/https://github.com/max0x7ba/atomic_queue/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "fb128338febbbd905ed16a5c5aef7cdbce48dd58cbd888f7bf4bdafaff778b50"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90ae48ae83150e93a6a4ad22a25c27e3a2b343cb79fdcc5bfdcc4070c68941d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90ae48ae83150e93a6a4ad22a25c27e3a2b343cb79fdcc5bfdcc4070c68941d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90ae48ae83150e93a6a4ad22a25c27e3a2b343cb79fdcc5bfdcc4070c68941d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "90ae48ae83150e93a6a4ad22a25c27e3a2b343cb79fdcc5bfdcc4070c68941d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c507cf1af264076a0915bfddbb055ab2096a541693c975a87c3a8c6d47e8107b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c507cf1af264076a0915bfddbb055ab2096a541693c975a87c3a8c6d47e8107b"
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