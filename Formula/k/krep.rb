class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https://github.com/davidesantangelo/krep"
  url "https://ghfast.top/https://github.com/davidesantangelo/krep/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "ed5253ef536e3dfdf62ec4f4b4260d853c9427704e8c9d40f7aab4adb8ca2a78"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19c6156ff1295e120871f58141db7be67343d6665b186be9eccd193ec730e808"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29847f6fb916d56dd2216a8e20d733f342095ef746310a6a25ca26e051601ea9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc0a050ea22ce4a8f6194f511fe5f8b563f34a37f521aab6803ccc8954bc75f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "254a16e2a7698b89f4c42d8f4e024909ef9c52df791303c2ba5a7573c3e190fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93b59e285ec1a409fd5938902b8dd65ac1816d465b84b259776299873e576364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5e82ffb0721b7497a8e8fcb0c15e73ab96fac76ff5c4dedeb478fba4fbe8dcf"
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