class DartSass < Formula
  desc "Reference implementation of Sass, written in Dart"
  homepage "https://sass-lang.com/dart-sass"
  url "https://ghfast.top/https://github.com/sass/dart-sass/archive/refs/tags/1.101.2.tar.gz"
  sha256 "a9bcc174999c20b158e24fb8aa645073d4112c81c1f066b3d7e5ce177c032f57"
  license "MIT"

  # Some tags are used for sass-api/sass-parser
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f535786573c3895c815f157696c27f88155c516f200a08caef55141b50e0517e"
    sha256 cellar: :any,                 arm64_sequoia: "4ae58b6d1f6e070d0ec193604691ad5301fedde54287903fb363327487d3a61b"
    sha256 cellar: :any,                 arm64_sonoma:  "a3efb29d61c15373501a917211aa575fdfc2af35c235314a2b7553a41d933d79"
    sha256 cellar: :any,                 sonoma:        "0ecaaf78dba44634f2db0b5096e5075fb195e03a793c8b39fdb135d95fc70838"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e12606426018910e4d77a92b1d3d1306cab92d8fd5590c86f2be5d6513be71cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2ee2fcf33d188ad4b2dd6d42322f6adfec15ee05abad2f862fb2256b0564227"
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