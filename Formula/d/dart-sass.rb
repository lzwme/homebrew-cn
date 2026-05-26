class DartSass < Formula
  desc "Reference implementation of Sass, written in Dart"
  homepage "https://sass-lang.com/dart-sass"
  url "https://ghfast.top/https://github.com/sass/dart-sass/archive/refs/tags/1.100.0.tar.gz"
  sha256 "d4f1fa35b6911c4a3fcb9bb8723e4ed6724c2aea71813dfce49ce65aed20b57d"
  license "MIT"
  revision 2

  # Some tags are used for sass-api/sass-parser
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fe028e3dc2040b9ee9b125244b4b828ef510a25caf90345160ac0755025deb78"
    sha256 cellar: :any,                 arm64_sequoia: "341ab4f37a99c5dac53caedd11d74292c058c185b77bcb84fe64346e5080b770"
    sha256 cellar: :any,                 arm64_sonoma:  "20ea853363c9cab12105c2a7f5e7a4ef085fde44cecbf4572789345eabe7c48d"
    sha256 cellar: :any,                 sonoma:        "c045c6860a8f2c407601fba3ecf5bc48c8af367f3fc0f8456fd37e11925f008b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15fca2c18a0bc3b13a7556c4bc3dbda5a3f7e76da2725add088c34c5efae3c52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4541c06d78451c3311e70975203059710b97b18dc01862273b45c7444b3f741"
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