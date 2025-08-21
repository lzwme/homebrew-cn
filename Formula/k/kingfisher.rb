class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.44.0.tar.gz"
  sha256 "6fe4f24d22194b7b93a16ef2008fd205b8b1e57348959ef1cba4318970b230c2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daab01b70dd1599b834285e0d4dd93268ddeafc6d56ef652ede5431b99f79b08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cd63a48a7f3833e06ad9db8aefdd8034cfd5fa4e34755bf18766154aa746b95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "22f9726d1aad6f61e47b170029c4d9ea65b77076f8be4564f9fdea99f26afde6"
    sha256 cellar: :any_skip_relocation, sonoma:        "08fe3883cd26d7e879d8781f51b67d9f57e72417f7c9702f703f8dd9136f37ca"
    sha256 cellar: :any_skip_relocation, ventura:       "70d22cb27b6c05a7556fa8c7cd8cc7a25d1ac0d16f951dc827bdc7d9ee44462e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "626a0091b751d8d0682ddfd2d21d9292a06556cfa30f6b88d54b7cb9d9efc764"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53c4562d7b442a93e61b762d6ccc551535e9ab2ad51bb3cc1f74c68e96e05116"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end