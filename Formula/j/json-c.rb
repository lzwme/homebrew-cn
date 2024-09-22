class JsonC < Formula
  desc "JSON parser for C"
  homepage "https:github.comjson-cjson-cwiki"
  url "https:github.comjson-cjson-carchiverefstagsjson-c-0.18-20240915.tar.gz"
  version "0.18"
  sha256 "3112c1f25d39eca661fe3fc663431e130cc6e2f900c081738317fba49d29e298"
  license "MIT"
  head "https:github.comjson-cjson-c.git", branch: "master"

  livecheck do
    url :stable
    regex(^json-c[._-](\d+(?:\.\d+)+)(?:[._-]\d{6,8})?$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c5514d30b5249b6d2a92e4dff45f56e2b081aa8811d13a20c84a3b911f6604d7"
    sha256 cellar: :any,                 arm64_sonoma:  "16b53cbbfaa2361f7e68f112f8ce706bc3d59738f377a26a1341c7122956e9b3"
    sha256 cellar: :any,                 arm64_ventura: "e6da2f2e625b6d6cf141bb4c3fe05ff0d1d42617321da078b48f32c9b01ddb0b"
    sha256 cellar: :any,                 sonoma:        "9630b473e74aa113e050b6ba4d3760d3f0d7c67c6460855217b312c597253eea"
    sha256 cellar: :any,                 ventura:       "91286eebfd88f8989056b56dad509e5b42aadda51e29708ef550da8a6b3314ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6afd63b22756b317e0dd21aa71644f47ec11996366bc60c8d5c9306f87044caa"
  end

  depends_on "cmake" => :build

  def install
    # We pass `BUILD_APPS=OFF` since any built apps are never installed. See:
    #   https:github.comjson-cjson-cblobmasterappsCMakeLists.txt#L119-L121
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_APPS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~'EOS'
      #include <stdio.h>
      #include <json-cjson.h>

      int main() {
        json_object *obj = json_object_new_object();
        json_object *value = json_object_new_string("value");
        json_object_object_add(obj, "key", value);
        printf("%s\n", json_object_to_json_string(obj));
        return 0;
      }
    EOS

    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-ljson-c", "-o", "test"
    assert_equal '{ "key": "value" }', shell_output(".test").chomp
  end
end