class Hq < Formula
  desc "Jq, but for HTML"
  homepage "https://github.com/orf/html-query"
  url "https://ghproxy.com/https://github.com/orf/html-query/archive/refs/tags/html-query-v1.2.0.tar.gz"
  sha256 "29a0dd1b43978c359958b0cae22fb52a8b4afe25f6544eba1ded73ad5041ec52"
  license "MIT"

  livecheck do
    url :stable
    regex(/^html-query[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81135a8d181f309660b4129417e76aa1c859ff23800afcf435e12b60beb90570"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "742d2be842abc6e8011844042440883de0333b2dc4df9dc45389bbd9793bbfc6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "997030934708bb0688ea32e4b50577ad5c6993178799d846ee9d1249eae56707"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2249b51d93356aba92d974c34e634c417c94d34d32546c07cef385f258975e3"
    sha256 cellar: :any_skip_relocation, ventura:        "d9158175d6587ec920fb171630db2acb155bacc7351b009a1898e497c3e88350"
    sha256 cellar: :any_skip_relocation, monterey:       "7b2c4a2a14989798a872e9cc7be712b924946abeaeb33b0d76b6466beec660ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f6abc4e205c1d12a69568a03b383b37446fe5761c395766976d41734543c57e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "html-query")
  end

  test do
    html = testpath/"test.html"
    html.write <<~EOS
      <p class="foo">Test</p>
    EOS
    output = shell_output("#{bin}/hq '{foo: .foo}' test.html")
    assert_match '{"foo":"Test"}', output
  end
end