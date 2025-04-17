class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https:github.comdavidesantangelokrep"
  url "https:github.comdavidesantangelokreparchiverefstagsv1.0.5.tar.gz"
  sha256 "a45e1941d234691e5379a368f12389f1693c565f937399f1b4a4f6a599ddaa72"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8904b585c6c62ed0e87e562534d48538865ac78f341eab1e10b7fbedab36c91c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c121ad9bc792a9f29e5028755f492ff48640402ea4e933fa9d9cbe970a2a628"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b75d8ee973595b504b91d2d156c24e7365f4c8ca152c2316d476a2a66f36bcfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "320d8fc887368d4a9dfe59ec7c314272e496c97099c35b53607209dea25a4cbe"
    sha256 cellar: :any_skip_relocation, ventura:       "49bc4ce550cb84bcadb5c9bbc41c5e8532eaf05fb2b77f5bfa9c2d7835026cc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67e72661d84eb9176b1661aa90d1fbceff5ae70231d1ac240df73d021cf80e10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d922a39b90962f88efb9fa2777551242138f07e7440d673d289c22030a0746f0"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}krep -v")

    text_file = testpath"file.txt"
    text_file.write "This should result in one match"

    output = shell_output("#{bin}krep -c 'match' #{text_file}").strip
    assert_match "1", output
  end
end