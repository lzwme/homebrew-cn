class MinLang < Formula
  desc "Small but practical concatenative programming language and shell"
  homepage "https://min-lang.org"
  url "https://ghfast.top/https://github.com/h3rald/min/archive/refs/tags/v0.47.1.tar.gz"
  sha256 "49dd7c4661e21c3a40fc4ec03a6860dfe7f60efe0a358c5dd917f84029b3959e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6ee77466373606d86016068213bbcc90805cb6d2b4dbdf59516902d60e947bd0"
    sha256 cellar: :any,                 arm64_sequoia: "9f8a40e25b3635acc1c8ec1ec1a43208caeb7936f04fb874840df97719ee3023"
    sha256 cellar: :any,                 arm64_sonoma:  "ca8d3528196a222aa81545e670b4694800efb01e9fa4f5868e10e0f37977768b"
    sha256 cellar: :any,                 sonoma:        "b30e6214370dbbd7d48218738dbab1a4c42a6c2eb0f4e73cc1692651a2e0b973"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ee8581caa4b05a46090d4163de1478aa03eb7769b85a8c7f04168df1d3e877e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ff578dfbc5b12c83d750d2ed9ae7e935e797d03bdc41de2736cd102149044d5"
  end

  depends_on "nim"
  depends_on "openssl@3"
  depends_on "pcre2" => :no_linkage

  def install
    # Remove bundled libraries
    rm_r(["minpkg/vendor/openssl", "minpkg/vendor/pcre"])
    inreplace ["minpkg/lib/min_crypto.nim", "minpkg/lib/min_http.nim"], /passL: "-B?static /, 'passL: "'
    inreplace "minpkg/lib/min_global.nim", /passL: "-B?static (.*) -lpcre([" ])/, "passL: \"\\1\\2"

    system "nimble", "build", "--passL:\"-lssl -lcrypto -Wl,-rpath,#{rpath(target: Formula["pcre2"].opt_lib)}\""
    bin.install "min"
  end

  test do
    testfile = testpath/"test.min"
    testfile.write <<~EOS
      sys.pwd sys.ls (fs.type "file" ==) filter '> sort
      puts!
    EOS
    assert_match testfile.to_s, shell_output("#{bin}/min test.min")
  end
end