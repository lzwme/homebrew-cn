class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "e2d4923d1f6391cf3a959c97d5327c62de442180165f31786eea15ddd9b108d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f955d3c60cc5419060bd67c9820c5f5f5fcb4357d04d1490212d4a61b86e1837"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54d3e753ff6915f078f9c630fd9783eee55dcc7cd2f09691cf3dd3bfc1b6ae63"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16544f2f36c42594a8e8690f803d2fa405852df3021fcf87b49bc417ea5ad6b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ccadfbe41a1879293dba162c512af94fad889abd62f899c592db5d12accedcc"
    sha256 cellar: :any_skip_relocation, ventura:       "cf6ec9ae17ac32c60ec48b5291a42e736c58cf1736a3125a7e7c6dc3e27deea4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47d6b3c0c9b116d26aa26fdaf6c9d783e713153a13a6dbfa9f2d3c5f8288d419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e69cc3531e02ae810c151489254e3f1734ab30c3799933db79d57506249ab193"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end