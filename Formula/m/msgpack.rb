class Msgpack < Formula
  desc "Library for a binary-based efficient data interchange format"
  homepage "https:msgpack.org"
  url "https:github.commsgpackmsgpack-creleasesdownloadc-6.0.2msgpack-c-6.0.2.tar.gz"
  sha256 "5e90943f6f5b6ff6f4bda9146ada46e7e455af3a77568f6d503f35618c1b2a12"
  license "BSL-1.0"
  head "https:github.commsgpackmsgpack-c.git", branch: "c_master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a161e2fb828f231162c3e36ecbebe93dbaa1270ff0e5a7fd531af138e4108d33"
    sha256 cellar: :any,                 arm64_ventura:  "a25d6e1381f812f45212ee16ab624dfc5b210a05f6d9ae4b77eeade014e16f87"
    sha256 cellar: :any,                 arm64_monterey: "062b0bc0266345dd2aa0dde051c19bbdc676c377a2cec821c2da952fef92f328"
    sha256 cellar: :any,                 sonoma:         "09430eae7575fad0f32c836bd000cf053c3bc12258ac17bed3fba74ffec280f6"
    sha256 cellar: :any,                 ventura:        "204dbc8810c0bf3f975817ab3d14be4e6a250a670e6e4f54784db9dcc06d26a9"
    sha256 cellar: :any,                 monterey:       "be4e47cda2cb1ebb6b878bd10170b550fc470725647fd1e394ece15180fb8ed6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7021b9a2421afcc1614788d01b4e4d7cbe44d90c7805a1d950f672f23f72c72c"
  end

  depends_on "cmake" => :build

  def install
    # C++ Headers are now in msgpack-cxx
    system "cmake", "-S", ".", "-B", "build", "-DMSGPACK_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # `libmsgpackc` was renamed to `libmsgpack-c`, but this needlessly breaks dependents.
    # TODO: Remove this when upstream bumps the `SOVERSION`, since this will require dependent rebuilds.
    lib.glob(shared_library("libmsgpack-c", "*")).each do |dylib|
      dylib = dylib.basename
      old_name = dylib.to_s.sub("msgpack-c", "msgpackc")
      lib.install_symlink dylib => old_name
    end
  end

  test do
    refute_empty lib.glob(shared_library("libmsgpackc", "2")),
                 "Upstream has bumped `SOVERSION`! The workaround in the `install` method can be removed"

    # Reference: https:github.commsgpackmsgpack-cblobc_masterQUICKSTART-C.md
    (testpath"test.c").write <<~EOS
      #include <msgpack.h>
      #include <stdio.h>

      int main(void)
      {
         msgpack_sbuffer* buffer = msgpack_sbuffer_new();
         msgpack_packer* pk = msgpack_packer_new(buffer, msgpack_sbuffer_write);
         msgpack_pack_int(pk, 1);
         msgpack_pack_int(pk, 2);
         msgpack_pack_int(pk, 3);

         * deserializes these objects using msgpack_unpacker. *
         msgpack_unpacker pac;
         msgpack_unpacker_init(&pac, MSGPACK_UNPACKER_INIT_BUFFER_SIZE);

         * feeds the buffer. *
         msgpack_unpacker_reserve_buffer(&pac, buffer->size);
         memcpy(msgpack_unpacker_buffer(&pac), buffer->data, buffer->size);
         msgpack_unpacker_buffer_consumed(&pac, buffer->size);

         * now starts streaming deserialization. *
         msgpack_unpacked result;
         msgpack_unpacked_init(&result);

         while(msgpack_unpacker_next(&pac, &result)) {
             msgpack_object_print(stdout, result.data);
             puts("");
         }
      }
    EOS

    system ENV.cc, "-o", "test", "test.c", "-L#{lib}", "-lmsgpack-c"
    assert_equal "1\n2\n3\n", `.test`
  end
end