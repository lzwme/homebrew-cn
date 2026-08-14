class DartSass < Formula
  desc "Reference implementation of Sass, written in Dart"
  homepage "https://sass-lang.com/dart-sass"
  url "https://ghfast.top/https://github.com/sass/dart-sass/archive/refs/tags/1.102.0.tar.gz"
  sha256 "7867797ec39c436462407eb3dc83555a7b8d157009838054bdbcd675f9857f14"
  license "MIT"
  revision 1

  # Some tags are used for sass-api/sass-parser
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eb3aaed4e5bf5c1cf6c83ef283e3be89086721920d0e3d76cf751f5cda33020e"
    sha256 cellar: :any,                 arm64_sequoia: "2ee571976126d8a320e6ef3c896dce5d1d547b2e6b9e7720cbf374a0751337a1"
    sha256 cellar: :any,                 arm64_sonoma:  "7a62e41be7c89bd58d45121f99a2ccdb40b366a7c00f49d48a2f3058024a7a17"
    sha256 cellar: :any,                 sonoma:        "0031f1c48cda7c9eb5b8430597a27a4186b02bca1ed9056f64b294c83baab036"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9c1471654ee9e744f2d0d9173b03b11339f48ab752b86ff08269fa228010c09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cd0b46e72cc66522190224b6805528269534a34e5368df162ee809d51f1a4cc"
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