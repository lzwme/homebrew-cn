class DartSass < Formula
  desc "Reference implementation of Sass, written in Dart"
  homepage "https://sass-lang.com/dart-sass"
  url "https://ghfast.top/https://github.com/sass/dart-sass/archive/refs/tags/1.100.0.tar.gz"
  sha256 "d4f1fa35b6911c4a3fcb9bb8723e4ed6724c2aea71813dfce49ce65aed20b57d"
  license "MIT"

  # Some tags are used for sass-api/sass-parser
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bb4d25f3c16fd142ec858935759984dd4f865524059c659da4d48551391f7f0e"
    sha256 cellar: :any,                 arm64_sequoia: "0125d3451250f8265eee83077871e018d682bb1255dcd4e6cb6119da50a8ce3d"
    sha256 cellar: :any,                 arm64_sonoma:  "732d94aee5714474a8c9a1771a0a805832a77267576d86fe150ccb09cbcf4c6a"
    sha256 cellar: :any,                 sonoma:        "c4b988a6bf51ed052020143120790899826f5103b9216fc19bc4ef8292b9a619"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d320bc4a82911d2108249d3b9fa7d676196335ed5fe26365badcbf11010cec3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0adf5b9564d1a4bec5ca2bb1f6d43d724fd694b864023198ef608f0f95659fb7"
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