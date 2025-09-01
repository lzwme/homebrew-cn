class Lr < Formula
  desc "File list utility with features from ls(1), find(1), stat(1), and du(1)"
  homepage "https://github.com/leahneukirchen/lr"
  url "https://ghfast.top/https://github.com/leahneukirchen/lr/archive/refs/tags/v2.0.tar.gz"
  sha256 "bf1f6ad5386687d3b9a4917de4f3bfdc39df3eaf30666494cdf3e6fb4e79fd91"
  license "MIT"
  head "https://github.com/leahneukirchen/lr.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b9161041b55afa97ed9eccf4f0e20fcf323258b79df81d8a30a7026c18cb2fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5775b78ff29b6c572458d068e3467f3637529d4cc27cc0418b23784743464ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "876b6d1e41b521615b4f33130852d116fe2bf43a5197cf8d2e8d2468940abb28"
    sha256 cellar: :any_skip_relocation, sonoma:        "e12d3814f9ac5a7208e9543a3c9e7cdb952b5d64025a86e3007395f6249d53bf"
    sha256 cellar: :any_skip_relocation, ventura:       "df482573ecfb07741693da8f0cde94122c6f72d3202110c68ad55a0bc44dc7cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c718d84d78694d8fc53a289a7d7451aa4c2de2aef488a615e50c3aab7e71734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36f47bd4e6b4e9409f57cd2e9f7cd8904c034b64c41605975add6e03717edf0e"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match(/^\.\n(.*\n)?\.bazelrc\n/, shell_output("#{bin}/lr -1"))
  end
end