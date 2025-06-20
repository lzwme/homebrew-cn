class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https:github.commongodbkingfisher"
  url "https:github.commongodbkingfisherarchiverefstagsv1.9.0.tar.gz"
  sha256 "749c5532ee49d9a358e8be9f925abda5589002398fec664bbd54db029af13e88"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0eb0cd6fba2e9977739200896b5c28e7cffc15411f857cd92588f9e958d7cb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d233a59ba04ccf23fec9bfe70941f8a0f4f80540cd8a553ccc39d6b21cc2a577"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a3ef8a03d5fade6934c8e6d7dcfc9c8ad08cd1c39650fda4a75f45f0d7768a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "276fbd7389fcf55c5b628cc1fcb92b944d6d54d16274aadc9f5d115c6cc7380c"
    sha256 cellar: :any_skip_relocation, ventura:       "8c194d7846d281bee9ad974f41e9628d55637bd2f2ede1a157019b0dd3833ceb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ddea66796e4dbfcb952c4fb5dd34663622d68e807ee260a527bb041a0a26c35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b23f276ef14ea3c135027104c67b74d0fe54781d38e82cb49e413f0d08b3e07"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kingfisher --version")

    output = shell_output(bin"kingfisher scan --git-url https:github.comhomebrew.github")
    assert_match "|Findings....................: 0", output
  end
end