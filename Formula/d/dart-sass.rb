class DartSass < Formula
  desc "Reference implementation of Sass, written in Dart"
  homepage "https://sass-lang.com/dart-sass"
  url "https://ghfast.top/https://github.com/sass/dart-sass/archive/refs/tags/1.105.2.tar.gz"
  sha256 "ef81110f75f08979a46616458bde0d4971526b51f00b36016c0188c3b112e1ee"
  license "MIT"

  # Some tags are used for sass-api/sass-parser
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "eda6c1e76a69a3c1d07c2672ad4c4f65853855bc5b2b7eb94861279613b21963"
    sha256 cellar: :any,                 arm64_tahoe:       "127053395bb2138ac48c4688b86b0d6940d6a0e869be132601ac0a5dbafebc9f"
    sha256 cellar: :any,                 arm64_sequoia:     "6740317f038e3bc2acede3cfab4dea3d258833ea4c6c2348fbc9ea49ee21d5dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f161b8b4f557bfda98a847240054a6bcfb2f7b9f1183aa83623a49433ebf4b24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ba4627353e533b6e17fa15752087ba2f9cf1ab3f306428af964796fd7149b1c0"
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