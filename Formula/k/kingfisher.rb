class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https:github.commongodbkingfisher"
  url "https:github.commongodbkingfisherarchiverefstagsv1.19.0.tar.gz"
  sha256 "0271eb3b933fdec85fffd7a376f0d6a876fb5d7b87c0901170cdd7bdc1b7ba25"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cd0d653b32e97b5505e012d760b105470add4835bd71220a7f7a80b4f4c5912"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "673c17c0188c3f58a7345f4ef2107db77b574958f7e75d24d5b9f82b901db2d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "124e53791cc7b4b1cf0b64800f6fa0701e1fe5e5c5258a0cfa8452510504f139"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6a516ec0ac9e986c3c56b14198392261853c7d07ff34b0a47f2619a9131b83c"
    sha256 cellar: :any_skip_relocation, ventura:       "9fa6122a4d23c1565e4ada89ba4aabd0a1e7b91d80589c6f5ae57a0de19aca60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "467f7e46b783b337d761130804ec075a26524e8733ecf0ac89f904adcd9ac67f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e764ca43aed9712fbfd4deac5e030a47ff33d3afbdd5f7570a09008ebc1a200"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output(bin"kingfisher scan --git-url https:github.comhomebrew.github")
    assert_match "|Findings....................: 0", output
  end
end