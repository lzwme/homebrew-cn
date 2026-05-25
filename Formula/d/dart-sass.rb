class DartSass < Formula
  desc "Reference implementation of Sass, written in Dart"
  homepage "https://sass-lang.com/dart-sass"
  url "https://ghfast.top/https://github.com/sass/dart-sass/archive/refs/tags/1.100.0.tar.gz"
  sha256 "d4f1fa35b6911c4a3fcb9bb8723e4ed6724c2aea71813dfce49ce65aed20b57d"
  license "MIT"
  revision 1

  # Some tags are used for sass-api/sass-parser
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ecaa37220cce0e08a8d1e78549e36c9eeb5fc0e0f563929fef4719651edf84a0"
    sha256 cellar: :any,                 arm64_sequoia: "83eedd4baf4b82bc6eeda02bfacfe26f0180a7e9ab139075fb9d483ce2465e96"
    sha256 cellar: :any,                 arm64_sonoma:  "267d723256748da7d326fae9bcde187b75c48123b841151322a2231380b6cf73"
    sha256 cellar: :any,                 sonoma:        "2cc32bc7b5be9aeebce1e46d236a62bfae61465609daccae3db3d8c7cfcb36d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75571dbc8008c9462d4cece310e2d18966134ddb812ba5777909cb2536d7bd22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "193d716f4d1bcb6a82c0f79edd9e41b3cc27da6fedf5c582af1666e15aeec4ad"
  end

  depends_on "buf" => :build
  depends_on "dart-sdk" => :build
  depends_on "dartaotruntime"

  resource "language" do
    url "https://ghfast.top/https://github.com/sass/sass/archive/refs/tags/embedded-protocol-3.2.0.tar.gz"
    sha256 "4e1f81684bc1666f03e52ddc790d0c2c22d99a5313fa2efe1dde4a5b5733c186"
  end

  def install
    ENV["PUB_ENVIRONMENT"] = "homebrew:sass"
    ENV["DART_SUPPRESS_ANALYTICS"] = "true"

    (buildpath/"build/language").install resource("language")

    system "dart", "pub", "get"
    with_env(UPDATE_SASS_PROTOCOL: "false") do
      system "dart", "run", "grinder", "protobuf"
    end

    args = %W[
      -Dversion=#{version}
      -Ddart-version=#{Formula["dart-sdk"].version}
      -Dcompiler-version=#{version}
      -Dprotocol-version=#{resource("language").version}
    ]
    system "dart", "compile", "aot-snapshot", "--output", "sass.aot", *args, "bin/sass.dart"
    libexec.install "sass.aot"

    (bin/"sass").write <<~BASH
      #!/bin/bash
      exec "#{Formula["dartaotruntime"].opt_bin}/dartaotruntime" "#{libexec}/sass.aot" "$@"
    BASH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sass --version")

    (testpath/"test.scss").write(".class {property: 1 + 1}")
    assert_match "property: 2;", shell_output("#{bin}/sass test.scss 2>&1")

    (testpath/"input.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style compressed input.scss").strip
  end
end