class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https://github.com/davidesantangelo/krep"
  url "https://ghfast.top/https://github.com/davidesantangelo/krep/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "ad8ddf43c93d96c681a555b8e614674332be6674fc2baef7d011902f0558e5bc"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e8fe7796515e5389c4ce73692c0c659499888ee7b29b2e3c3015644389781c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "150b2415272c560352b11ab3c30a8c151e050f4c4371bb31346ac69edc823543"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84fe2d1e44262ef89ce5cac8f06a973001d9872000c3f3933d15a3c5785f6e98"
    sha256 cellar: :any_skip_relocation, sonoma:        "c94d9eca1625b1cbcc7f7471894906948ce257a01223d68964ff151245ccbe09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f323eb1cccbe7eabbf8adb67b668abfe1c67f2e58be28a7226aa6743714815e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80ae9762e3e2c9856e98403b7d4f84a5d559648b8e499081b2bc0cc0e3dbf636"
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