class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "c6b4bc09a6ba01c2af0261ecf16198c4fbc841c5ad21a3bdaccaaf3a56a9718d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db723bb0ce4bccb01d566fa710bf3dfdc13dca6ef1406fe9f8794a765f7c6ff8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0b986a944518198338d4bc6a02ecde35d6418b7280b53a07db6b6ddb7a9896f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9dc25386ef38d6531b2dfc3cc383219183d810db9b276ea33aff7ca11e195b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "01395dc547e3ceb5c71b610c67818eee26b1bdbd404ffeedbb031150c8822bc2"
    sha256 cellar: :any_skip_relocation, ventura:       "1dc512cb1b389ede2e0e796be32c4c6c224bf12ea62a125ad66069fe6c8ff65d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b91f379ca9f73ec249eed5421b902c3d4ca3cfa6a16133ea7fbe88fe997dc42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa0aecf88de03b9876cba1240364e728a2be8aad16b9d23dc9d90efd72bdb11b"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output(bin/"kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end