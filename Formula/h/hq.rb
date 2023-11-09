class Hq < Formula
  desc "Jq, but for HTML"
  homepage "https://github.com/orf/html-query"
  url "https://ghproxy.com/https://github.com/orf/html-query/archive/refs/tags/html-query-v1.2.1.tar.gz"
  sha256 "db6c574acc701f337285839e1f7a3a6e30267fd0ba69733a9a74e637b827bcdb"
  license "MIT"

  livecheck do
    url :stable
    regex(/^html-query[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c65ca9e471a5bef7a3a8bfb6f6dd78e95b1b78995185689d09b419643fbb1cab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6656227b01124234c3a1505441834865ae58252a62cede9d1c60fdd44ec3e41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56583761d97662e07eb645a8b31b0666189849d0de2b0e55d962660b2a9a23ad"
    sha256 cellar: :any_skip_relocation, sonoma:         "fab9a596539febf33d15192d17875b7fd5d15b7201da7d87b58b2eead558d728"
    sha256 cellar: :any_skip_relocation, ventura:        "f69e41e1eff45cf7b0de95e1d33afa7dc7b5ccf9d14a75e3976278c1c05c13fe"
    sha256 cellar: :any_skip_relocation, monterey:       "86a496b6b4e311349ebb1490129de0daa7fb0248be2ccaf6f2bb08a9ef1b080c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01c4eadd2abc47f2a457f3b18dfedf3985996744d392fce30d7b1898eeda9df4"
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