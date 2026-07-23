class DartSass < Formula
  desc "Reference implementation of Sass, written in Dart"
  homepage "https://sass-lang.com/dart-sass"
  url "https://ghfast.top/https://github.com/sass/dart-sass/archive/refs/tags/1.101.5.tar.gz"
  sha256 "954359aae72769e540c9ea5c3775c2f0c29310e2d495990df6acbfea49fa6c72"
  license "MIT"

  # Some tags are used for sass-api/sass-parser
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "08690b0d38e1579ebddad0313dd6d161cf6a673ed8a2b2ee0cc6c329a71bd0ea"
    sha256 cellar: :any,                 arm64_sequoia: "3667820a0931f21b4013a0e040dfa99136ff37be697e91b8f3daaa949928f6f1"
    sha256 cellar: :any,                 arm64_sonoma:  "2ecec43fe5cd9cf5b28a23700d43d87e34128b923c2e8e0571b22d205f8e2f2b"
    sha256 cellar: :any,                 sonoma:        "aa5a98c7453f65c16fef115ced963931891c20c05bf45f303b06dad3acd879a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5e0725f6e8897109bf7bbe755ea77f801ad2d3d11f1e79741e254b3eb02d358"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d63524621f415dc6ddc5189c4773c786ac69f106cb5163643629cb09e5d3a96"
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