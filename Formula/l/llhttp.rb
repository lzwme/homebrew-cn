class Llhttp < Formula
  desc "Port of http_parser to llparse"
  homepage "https://llhttp.org/"
  url "https://ghfast.top/https://github.com/nodejs/llhttp/archive/refs/tags/release/v9.3.0.tar.gz"
  sha256 "1a2b45cb8dda7082b307d336607023aa65549d6f060da1d246b1313da22b685a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cc07b427e2545215f867aaae837cca859ab4d7f977a903f2bf56866e454191e1"
    sha256 cellar: :any,                 arm64_sequoia: "cb4f21fcb1c909d42679963fec493d1d84202d05e56d64ec849298216a50cc74"
    sha256 cellar: :any,                 arm64_sonoma:  "fec602a007081b888cbad8c6bb8992c57493fce0c8896c9218829ac5ddb7b8f0"
    sha256 cellar: :any,                 sonoma:        "90a5d55c5c8ce33af4fba41a2bc408091aeec6311ac1684fd963004212425af6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3011938e267301ad551e6cc7697b35757e322ab9b1df8420c2516e157b91321"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2f3274725d2060bf5c6a19d95e211a4c34ffbd37385eb7b869d8e2b146ba674"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~'C'
      #include <stdio.h>
      #include <string.h>
      #include <llhttp.h>

      int handle_on_message_complete(llhttp_t* parser) {
        fprintf(stdout, "Message completed!\n");
        return 0;
      }

      int main(void) {
        llhttp_t parser;
        llhttp_settings_t settings;
        llhttp_settings_init(&settings);
        settings.on_message_complete = handle_on_message_complete;
        llhttp_init(&parser, HTTP_BOTH, &settings);

        const char* request = "GET / HTTP/1.1\r\n\r\n";
        int request_len = strlen(request);
        enum llhttp_errno err = llhttp_execute(&parser, request, request_len);

        if (err == HPE_OK) {
          fprintf(stdout, "Successfully parsed!\n");
          return 0;
        } else {
          fprintf(stderr, "Parse error: %s %s\n", llhttp_errno_name(err), llhttp_get_error_reason(&parser));
          return 1;
        }
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lllhttp"
    assert_equal "Message completed!\nSuccessfully parsed!\n", shell_output("./test")
  end
end