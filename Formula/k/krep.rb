class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https://github.com/davidesantangelo/krep"
  url "https://ghfast.top/https://github.com/davidesantangelo/krep/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "2d0f254dfcbf49b69ab39d7874a290b4de3c869c0ae7818494bba5adc835581a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ebe11f6c86b481fc6f0b624e5256cdfd2eec8ff9a38577c99b89265d4c8b741e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa0188d727983867eabd3e0a31ecdc80bb7ff5bb5793e27cbd20d7fc4e58be1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cab793f9a960b517588f8eb2bd7523dcbb1492b38937deda40f5fe9cd0022d14"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e16766c7bdc6669df2936da23eff1652c6ce989dd570c47853dbbb0088361cf"
    sha256 cellar: :any,                 arm64_linux:   "0baa5a80357b29f0745de8d4e56cdb55688ee069bdcf5f68b5997e4e07eec65d"
    sha256 cellar: :any,                 x86_64_linux:  "4f46f8be47bbae47b75da3298071b3baef55f1a6babd599b9607534d399d5fa9"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.major_minor.to_s, shell_output("#{bin}/krep -v")

    text_file = testpath/"file.txt"
    text_file.write "This should result in one match"

    output = shell_output("#{bin}/krep -c 'match' #{text_file}").strip
    assert_match "1", output
  end
end