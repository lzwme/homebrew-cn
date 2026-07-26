class DartSass < Formula
  desc "Reference implementation of Sass, written in Dart"
  homepage "https://sass-lang.com/dart-sass"
  url "https://ghfast.top/https://github.com/sass/dart-sass/archive/refs/tags/1.102.0.tar.gz"
  sha256 "7867797ec39c436462407eb3dc83555a7b8d157009838054bdbcd675f9857f14"
  license "MIT"

  # Some tags are used for sass-api/sass-parser
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "95bebd5fddf4cbfbade32b0f5c33f7a5b327967bb701bf37e2705d919214e013"
    sha256 cellar: :any,                 arm64_sequoia: "d47b20c157bcdfc8fcad2bd6346447be0a2cb2564b986787b14aa7654efaa25e"
    sha256 cellar: :any,                 arm64_sonoma:  "05e44d46cd2d93434849c666381aed277c851981ea82246da960114f8f67fc9d"
    sha256 cellar: :any,                 sonoma:        "b6c827fd55d1c2d73fc13754ff12d342ac76151fa02db9cce1becee2a94e259c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d405c5a941abc57b41aa1401fe7627bc3d9a7d15a71c8d8e688f5271ab06be56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9e7bcd81b97365f8319521e7d58d50b40eda62ad2ae7efec46754286d38567e"
  end

  depends_on "buf" => :build
  depends_on "dart-sdk" => :build
  depends_on "dartaotruntime"

  resource "language" do
    url "https://ghfast.top/https://github.com/sass/sass/archive/refs/tags/embedded-protocol-3.2.0.tar.gz"
    sha256 "4e1f81684bc1666f03e52ddc790d0c2c22d99a5313fa2efe1dde4a5b5733c186"

    livecheck do
      url :url
      regex(/embedded-protocol[._-]v?(\d+(?:\.\d+)+)/i)
    end
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
      exec "#{formula_opt_bin("dartaotruntime")}/dartaotruntime" "#{libexec}/sass.aot" "$@"
    BASH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sass --version")

    (testpath/"test.scss").write(".class {property: 1 + 1}")
    assert_match "property: 2;", shell_output("#{bin}/sass test.scss 2>&1")

    (testpath/"input.scss").write <<~SCSS
      div {
        img {
          border: 0px;
        }
      }
    SCSS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style compressed input.scss").strip
  end
end