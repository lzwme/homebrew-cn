class AtomicQueue < Formula
  desc "C++14 lock-free queues"
  homepage "https://max0x7ba.github.io/atomic_queue/html/benchmarks.html"
  url "https://ghfast.top/https://github.com/max0x7ba/atomic_queue/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "08157c1ffa6dee0ee9c34a102ee1a9da91b822e213a7cce79d6d8aed9c7a7979"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9a4f80416f7dd14c64ecfbcc3f69fe047c5d036f145ad071ef6b0b22e3e683c5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9a4f80416f7dd14c64ecfbcc3f69fe047c5d036f145ad071ef6b0b22e3e683c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9a4f80416f7dd14c64ecfbcc3f69fe047c5d036f145ad071ef6b0b22e3e683c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "909aa19375ab3cf179685fed3df9d63e665d6f2062078d947c6044d6dbe618cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "909aa19375ab3cf179685fed3df9d63e665d6f2062078d947c6044d6dbe618cb"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  # Apple clang has no `libatomic`, which the meson build requires since 1.9.3
  patch do
    url "https://github.com/max0x7ba/atomic_queue/commit/73647516617e9ddb356f7f24811e4b0ae58672d1.patch?full_index=1"
    sha256 "5b750112ef279aba5c30770953ebe1b2ebcc2a0fd0e9e2198330c649682cb52c"
    type :unofficial
    resolves "https://github.com/max0x7ba/atomic_queue/pull/108"
  end

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