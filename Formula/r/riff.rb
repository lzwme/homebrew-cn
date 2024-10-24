class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https:github.comwallesriff"
  url "https:github.comwallesriffarchiverefstags3.3.5.tar.gz"
  sha256 "fab34e7d4386003b772bc8c0ab322bf504951d8f50063d61feb140443fbb5144"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35bb5a1a837e4f8c069221979187bf6e79d5868fa5141e292aff5b171bdf6144"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f0212f9b4f63b076ae034a426e5baef04a7eeea9d28fba51c136e8c6e9dd311"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c5adda5167c53c1faf9b9ebc70896921c8f7f48d1e8fb91f53351b21e7eb5dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "a41de4abe3d95a7e72d51a66fd00dc5c719599de6e59827978831a38896f89c8"
    sha256 cellar: :any_skip_relocation, ventura:       "078eed67eda5f2c6699875105e99de07c5de57a457cfae1cf431277e39e73251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0eed816269ebcbfed70d4e4f895b21143b55df88bf99695c95c6f304cb465cac"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}riff etcpasswd etcpasswd")
    assert_match version.to_s, shell_output("#{bin}riff --version")
  end
end