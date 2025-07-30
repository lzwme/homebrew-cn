class Hellwal < Formula
  desc "Fast, extensible color palette generator"
  homepage "https://github.com/danihek/hellwal"
  url "https://ghfast.top/https://github.com/danihek/hellwal/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "ad5bd1e4ec7fc747179b4e20e655c1857f3da80c56ce3f82de835aa73550a7a4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df2140e201924efe6b60c733707397fa18fed991d183bc4d0aa9626d15b7565b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea6fab12cdc2a7b7e04146b0932aafe0bb382384f30e9b9911e6cf60da9d9b59"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ac64935c05b01420f37f92aa623bdb4d748a1d03c04b064d37e1b2a0c741230a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e28c9236c96e6e203400e6290513649b4a27b8125ec6ca6b6c21069ee3c789e6"
    sha256 cellar: :any_skip_relocation, ventura:       "210a465c07ab34be559c95f997ba5633ce09898209a0121fad7bb9e65ffa7401"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f75463bcbd3370905aa02787ee63378dc8cc1a34a1cab30f0ed4cc488ee93ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2df621a0a50103ec43d38ed30212ddd9e303003aee23afe5191f46e0eeb2de5"
  end

  def install
    system "make", "install", "DESTDIR=#{bin}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hellwal --version")

    (testpath/"hw.theme").write "%% color0  = #282828 %%"
    output = shell_output("#{bin}/hellwal --skip-term-colors -j -t hw.theme 2>&1", 1)
    assert_match "Not enough colors were specified in color palette", output
  end
end