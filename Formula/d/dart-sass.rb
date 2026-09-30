class DartSass < Formula
  desc "Reference implementation of Sass, written in Dart"
  homepage "https://sass-lang.com/dart-sass"
  url "https://ghfast.top/https://github.com/sass/dart-sass/archive/refs/tags/1.105.1.tar.gz"
  sha256 "0744079d7712afa814ad6a8fb61bd4006a5902cb6746d92b13fb0d38234547c4"
  license "MIT"

  # Some tags are used for sass-api/sass-parser
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "607aa3082700dd61175ada9ca669aa1ccd757b367bbb71d7a275518b95e1c3b4"
    sha256 cellar: :any,                 arm64_tahoe:       "cbb3aafcc25ecf9a0c46258b493f058d3b1c7840a75b7c05fa347b7f60c682c8"
    sha256 cellar: :any,                 arm64_sequoia:     "7a71b21e6b937d631f06c9b81e402e0ed4f0285ffb8a523dbfec4d8530a8577d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4d0f63f4214e943f674c4a256ddf18092f1ff7adc3c1193090958551df9c76b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8d677bcc8835cd98093f400587b4c98d5e776d28d599ce5c9aa6fab18fd8771e"
  end

  depends_on "buf" => :build
  depends_on "dart-sdk" => :build
  depends_on "dartaotruntime"

  resource "language" do
    url "https://ghfast.top/https://github.com/sass/sass/archive/refs/tags/embedded-protocol-3.3.0.tar.gz"
    sha256 "17ea26c8ae3bb03a7dc72f841d7d832b64410230483cdde8807ab4b7f9204ce8"

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