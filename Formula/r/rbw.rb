class Rbw < Formula
  desc "Unofficial Bitwarden CLI client"
  homepage "https:github.comdoyrbw"
  url "https:github.comdoyrbwarchiverefstags1.11.0.tar.gz"
  sha256 "e8c54b5bc9717a5a16ac86ae54b48e5274562b0d032a813e42e2e18351069f63"
  license "MIT"
  head "https:github.comdoyrbw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a4425ae55e82d117e351483a4bd84a3814ae1eb1ce114dbb788e9cbf8eaddf5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3f9f0516f064133c32741450d6ee8ac9ec9ba89576d457a235da47aea9faf5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07f10ea4803a73f914f7a79287c2a0415038221c559143ab0fbcc93ab083c3a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad7edf7ddcc65cdc3917d3cbeb00169a905a07c5eb3797d70f3a9c4fb442e92f"
    sha256 cellar: :any_skip_relocation, ventura:        "7dac1dfe4e3beb9e08f8ce4c188245c0783895df889d73db27a3a9fd2b7ec9ab"
    sha256 cellar: :any_skip_relocation, monterey:       "2c21713a401dad798516cf33dfbae3bdecf321a1ff854e447daab2ef21f0fa6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b228a28e85089f277dbaf0eed51aebbb38bb2b2093e6b401270644d88ad542c"
  end

  depends_on "rust" => :build
  depends_on "pinentry"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"rbw", "gen-completions")
  end

  test do
    expected = "ERROR: Before using rbw"
    output = shell_output("#{bin}rbw ls 2>&1 > devnull", 1).each_line.first.strip
    assert_match expected, output
  end
end