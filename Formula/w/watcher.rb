class Watcher < Formula
  desc "Filesystem watcher, works anywhere, simple, efficient and friendly"
  homepage "https:github.come-dantwatcher"
  url "https:github.come-dantwatcherarchiverefstags0.13.2.tar.gz"
  sha256 "d7c788fd55673aef59567f75f061255c6243db583d3bfd5944768b3ee6510cee"
  license "MIT"
  head "https:github.come-dantwatcher.git", branch: "release"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2a343d052580b66274a1d488a6c3394e8b922491fffde9f68b5aa6e1d61ac7f5"
    sha256 cellar: :any,                 arm64_sonoma:  "b7319e77d06d5ff60f44943b65e73e93c9aa626db77e319a6abc8c632cf70274"
    sha256 cellar: :any,                 arm64_ventura: "f98c2d11e1493926f0ff2e0160a6b1f783194e7c9b22e18e4655fcc0c7678bdd"
    sha256 cellar: :any,                 sonoma:        "9839d335a3dd53e0843e120b38b4378540be36251328bb2ad6065c1eedf5f7dd"
    sha256 cellar: :any,                 ventura:       "ba201a96cc841cdac0e227fed63d6ce1b607c43f27c56a24050fa638eb52e1f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0d4587ae7acc2536881ba6e74f70b7c278209d9e8c71ea7471914ff6e04f34c"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}wtr.watcher . -ms 1")
    assert_match "create", output
    assert_match "destroy", output

    (testpath"test.c").write <<~C
      #include <wtrwatcher-c.h>
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
    system ".test"
  end
end