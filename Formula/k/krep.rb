class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https:github.comdavidesantangelokrep"
  url "https:github.comdavidesantangelokreparchiverefstagsv1.1.1.tar.gz"
  sha256 "815834208b2abd15386374b7d9258f9b37fec40cc3419e2be994d1f7965ef661"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec41951417e6e7f9adae410f605a2cfae075ce7160e466cc201e2e47eae62528"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ce6535e00c3518f9e520bfba88621d675d57ea90324605a1e152c5191c75763"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9cd4871cceebe38c4e114d81598cef06343bb0f79900dc9d28166340ae98246a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d474473ea8054a8ca4f450b941962b22b5f6e7709feebc39a6ddf7bfb2b514fa"
    sha256 cellar: :any_skip_relocation, ventura:       "43171137b16d06878bea4eceabbd0d023931d342b9a97c6a1e9ae4c4229c364c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8eb4543619a107cd7cdae98dbdd4c96b2bfd8acf524c7f8f663ff9018f309503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd2c2c0e20727b98ca17cbe33b00697e88fdbc6fb7614ce92276cd2f9b7e13b5"
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