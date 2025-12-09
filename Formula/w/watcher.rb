class Watcher < Formula
  desc "Filesystem watcher, works anywhere, simple, efficient and friendly"
  homepage "https://github.com/e-dant/watcher"
  url "https://ghfast.top/https://github.com/e-dant/watcher/archive/refs/tags/0.14.1.tar.gz"
  sha256 "c844751810dc0223f978d62c094de6ce3ca5a9c39b147dd714ab34ce089aa039"
  license "MIT"
  head "https://github.com/e-dant/watcher.git", branch: "release"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cc2ea162bf77e4fab0827ba5acf9599fede9d09282acd7ffdbaf4514da3ae615"
    sha256 cellar: :any,                 arm64_sequoia: "41188769e6305d9f1a5b4a2298e1c3c5b63dcd13464ca83f051da0dbf06f9c00"
    sha256 cellar: :any,                 arm64_sonoma:  "11bb0efa23b74f3e585a60d6bea34bd89072b01932f87a2311332e42ccca597c"
    sha256 cellar: :any,                 sonoma:        "6d7cfe77c3d4d24d96f588977d3b9fe5366fb76746d695e232ebd92ee6df4485"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "376ad1ad0f25ac2e3831cf064c54f1321269f0d82d9e4d77e1e1b152aee51abe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf07a8011babfd9e97fae600427f8fecf021d8907fa1664ef425885d2b73da05"
  end

  depends_on "cmake" => :build

  conflicts_with "tabiew", because: "both install `tw` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/wtr.watcher . -ms 1")
    assert_match "create", output
    assert_match "destroy", output

    (testpath/"test.c").write <<~C
      #include <wtr/watcher-c.h>
      #include <stdio.h>

      void callback(struct wtr_watcher_event event, void* _ctx) {
          printf(
              "path name: %s, effect type: %d path type: %d, effect time: %lld, associated path name: %s\\n",
              event.path_name,
              event.effect_type,
              event.path_type,
              event.effect_time,
              event.associated_path_name ? event.associated_path_name : ""
          );
      }

      int main() {
          void* watcher = wtr_watcher_open(".", callback, NULL);
          wtr_watcher_close(watcher);

          return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lwatcher-c", "-o", "test"
    system "./test"
  end
end