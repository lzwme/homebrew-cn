class DartSass < Formula
  desc "Reference implementation of Sass, written in Dart"
  homepage "https://sass-lang.com/dart-sass"
  url "https://ghfast.top/https://github.com/sass/dart-sass/archive/refs/tags/1.101.7.tar.gz"
  sha256 "28536c463fcc91b42969c7c53dfcd9d4af453b5691ffd8e60be17038d4ffca12"
  license "MIT"

  # Some tags are used for sass-api/sass-parser
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3d19c33ff0d280e592be8ee48a5cb76ce0d90d8907e49286d579ef2b8bd12d8d"
    sha256 cellar: :any,                 arm64_sequoia: "2daf063aa7b1315dcf41d6dcde376902015135b92ad53c3721ff94caee4b8087"
    sha256 cellar: :any,                 arm64_sonoma:  "f15bb285ae35ead4b150ea4a6e9af105947e0af7a9221562240576590cdcdcf7"
    sha256 cellar: :any,                 sonoma:        "56f6b09f36bbf030b594a340fe4f3fd895cd7df080f55ca772795e79bc40301b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "035d6f6e9602c37455494f26c65c8bc9a062b6e09bce464e29afc8fda0618901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e55e91c86ae566b12a80350ad3e060c02455209669e4e391b572543b702b41ff"
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