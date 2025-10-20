class Zsv < Formula
  desc "Tabular data swiss-army knife CLI"
  homepage "https://github.com/liquidaty/zsv"
  url "https://ghfast.top/https://github.com/liquidaty/zsv/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "218d184dabf847f97f6920dfa3ed4626f6816420109e3d15739151d7bfeca2ec"
  license "MIT"
  head "https://github.com/liquidaty/zsv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3729ee8c4eb1dce36b70fb206912248f357146485d0a39df840e376c712c576a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e649d91755a4572aaab24b5e17a6d1fe4853b7c86bad15f8ba572886e4d40a0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebea84879a8b0fbe6498ca58dbf7c66afe6660ded5dc708cbba30ed8c2107c43"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ec7b16bd2e324745b9c437d1ab9147d01afcd6921e47fba190aa6008f494cbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f836e2ad7cc362c58fc5785cb851d4f35940487aa45546f4c5e3ff90b761ec67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "967bcebc244bf695843cada533bbcaa4daf071ea484a47364ed78590a8fd758b"
  end

  depends_on "jq"

  uses_from_macos "ncurses"

  def install
    system "./configure", *std_configure_args
    system "make", "install", "VERSION=#{version}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zsv version")

    input = <<~CSV
      a,b,c
      1,2,3
    CSV
    assert_equal "1", pipe_output("#{bin}/zsv count", input).strip
  end
end