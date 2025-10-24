class Zsv < Formula
  desc "Tabular data swiss-army knife CLI"
  homepage "https://github.com/liquidaty/zsv"
  url "https://ghfast.top/https://github.com/liquidaty/zsv/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "63b4d8221a7e27b7ef7842afb3233e32cd2473d3e3389a0daa86833bfe56b50d"
  license "MIT"
  head "https://github.com/liquidaty/zsv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c82ecd50aad012264d4bd49ccbc74935cb8e2162259e783860edaf186e98c30b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcb86fbd21ce9b4cefccbf90e7c2b29f4c559234e3641c224e1b4d9209737a8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "760bd2a6d92d1548ea7c41d43aebd7cc91945ab08557487ad6458fa515f4b9ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "76b143bb506116cb65017ce1f068084ff7a9268dc52797e63b18f9e7f3c6255c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bd9c0416d51f73f1e17031dac061d228b23a362e89a5abe076c855643bb2650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ebcee8626372b956ee5e917d18edeb2887921b6c1b1725f7f4e1ccf1d671a13"
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