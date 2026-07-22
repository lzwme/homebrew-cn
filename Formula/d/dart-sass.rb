class DartSass < Formula
  desc "Reference implementation of Sass, written in Dart"
  homepage "https://sass-lang.com/dart-sass"
  url "https://ghfast.top/https://github.com/sass/dart-sass/archive/refs/tags/1.101.3.tar.gz"
  sha256 "2f7d009637b994b2d80e353baac3b9ebbc0a6fa962dcc4cbfe9f0165e82069a2"
  license "MIT"

  # Some tags are used for sass-api/sass-parser
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4de24d15fd42e777989ac13944acba6d05e3b325c0034f6fa7512b749cf06ac6"
    sha256 cellar: :any,                 arm64_sequoia: "13e5dc44c398247ea9c43be5c543a317fb4535050305d6f4f658e0752adc0e38"
    sha256 cellar: :any,                 arm64_sonoma:  "bb5b0e57b1d187b4cd419dbd04cf880d2a0c826952fb5242cd2c98def63b982b"
    sha256 cellar: :any,                 sonoma:        "74c80ad674b6f561ac5de8102e73c197fa46a249307092cfcc78414d2c86217e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d799e6d19bb1ad362afd009e9e7211c0a6d3d765a7d010b69a628c6d08a7539c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c354c87cc75ea4510f4d3fa16c21f100a1f3d73fa3f3898b8f5e803155596a7"
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