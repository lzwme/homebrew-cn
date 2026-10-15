class Code2prompt < Formula
  desc "CLI tool to convert your codebase into a single LLM prompt"
  homepage "https://code2prompt.dev/"
  url "https://ghfast.top/https://github.com/mufeedvh/code2prompt/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "de0fe811914bee2d03a0025e734d702d1cb50472dd75c42017cc65ac9435e481"
  license "MIT"
  head "https://github.com/mufeedvh/code2prompt.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "b090851dfcd0dc2583c7c377ed6b59cdf2d830efe521362c56d59eb4f434eeea"
    sha256 cellar: :any, arm64_tahoe:       "2be0d24fdbc8bfb222bcff99065ba5867b8559642ad7b78083751f35f1ad7632"
    sha256 cellar: :any, arm64_sequoia:     "1047431409b54042918926912d428ca67dc8dbb956a41c07109de3504b36599a"
    sha256 cellar: :any, arm64_linux:       "ae335c12d5b34b8a069e377d9e2c0c770f967b0f94ed416961d606db997869a7"
    sha256 cellar: :any, x86_64_linux:      "540c490ca2c252c350d64c30e4cc95c5c213c2006127e23a9113508dbc32f171"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # `cargo update --precise 0.9.114 openssl-sys` for minimum needed to use OpenSSL 4
  patch do
    file "Patches/code2prompt/4.2.0-openssl-sys-0.9.114.patch"
    type :backport
    resolves "https://github.com/mufeedvh/code2prompt/commit/f9ff9796f9835d0aae143d40bfc91a02a6c5ada0"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    system "cargo", "install", *std_cargo_args(path: "crates/code2prompt")
  end

  test do
    require "utils/linkage"

    assert_match version.to_s, shell_output("#{bin}/code2prompt --version")

    (testpath/"test.py").write <<~PYTHON
      def hello_world():
          print("Hello, world!")
    PYTHON

    system bin/"code2prompt", "--no-clipboard", "--output-file", "test.json", "--output-format", "json", "test.py"
    json_output = (testpath/"test.json").read
    assert_match "ChatGPT models, text-embedding-ada-002", JSON.parse(json_output)["model_info"]

    [
      formula_opt_lib("openssl@4")/shared_library("libssl"),
      formula_opt_lib("openssl@4")/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"code2prompt", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end