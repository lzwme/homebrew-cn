class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://ghproxy.com/https://github.com/ordinals/ord/archive/refs/tags/0.12.2.tar.gz"
  sha256 "80083386219b7b68a2f764a12ad5afbc76877974fcb2e32bbd927e82797d3843"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "acae08b3afdcf51621517e4797e646a34858c6bd7ea7916cf1bf550ca56e7f08"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5815aac3b62ab664330d7f7765c7e5adf39bb8e8870da855544e3f25b7bc5046"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5291a3c8ec699495137591652e3a8d95ba406759fd35797f07356115f6e8121c"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4363bd40d70678551ec8836eec88e1fa5b8d9333fbc12af4831a3f4157deeeb"
    sha256 cellar: :any_skip_relocation, ventura:        "3686889c746cfebab9fa4f676a3b6c5089847ebbfda09a21596de2c54ad36145"
    sha256 cellar: :any_skip_relocation, monterey:       "a948f79c1dfc2f8826ed6b1d63c7827955fb32d0385daa396e6b1fd5e94053cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfda066123724bc0118135a5497bf3436d55865d05f5080bcb20e6dc3339c963"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected = "error: failed to spawn `bitcoind`"
    assert_match expected, shell_output("#{bin}/ord preview 2>&1", 1)

    assert_match "ord #{version}", shell_output("#{bin}/ord --version")
  end
end