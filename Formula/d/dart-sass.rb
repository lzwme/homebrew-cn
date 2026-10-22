class DartSass < Formula
  desc "Reference implementation of Sass, written in Dart"
  homepage "https://sass-lang.com/dart-sass"
  url "https://ghfast.top/https://github.com/sass/dart-sass/archive/refs/tags/1.106.1.tar.gz"
  sha256 "5742589847d5f08000f21cf9df61f70ab61dec486f43301cf5e58d88086e2313"
  license "MIT"

  # Some tags are used for sass-api/sass-parser
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "a793aa11b81072670094412ca8316614e0d0df0d08784b7ef187854e946064a4"
    sha256 cellar: :any,                 arm64_tahoe:       "86de5462c7adf2e0bb6c633162a5ecc8fc051cb2d7447a131e05b633d2dadad8"
    sha256 cellar: :any,                 arm64_sequoia:     "f34875b5aa860f29a1067b3b4d9f50f3189483db406c4ac4fad440096cb3b333"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1a91595d9e1013af3b6711d4a628f157744d5e01bbc183eb2220b8356bf082ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f8e8f24fcf9545398dcb4dfd5495198bf9e4b585d7e663b85485953bdf4dbafb"
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