class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https:railway.com"
  url "https:github.comrailwayappcliarchiverefstagsv4.5.2.tar.gz"
  sha256 "1503c2aafc6e6b0b01192f2b834e8bcc05cca215f6a7bab08ae0c03aeabc3514"
  license "MIT"
  head "https:github.comrailwayappcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab3be25ba90e6c816bccab391d98c1477c3bc8361e00d178a4782d269cf199d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "711a7f5ec0473adfa2b4adaab148ab5dd55a3ab2090e3a3047546fe3eeff87f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8da47f7383d4c8539d4bbb6ae713a861dafae59176283827705b1c8bbcee8501"
    sha256 cellar: :any_skip_relocation, sonoma:        "04febb19d13e21acca9873eb0b15da642e93f1a26d4ad414672208e0873c90e2"
    sha256 cellar: :any_skip_relocation, ventura:       "c92cf273e9f7cf1ca5f50259aec7222177e94198ddc995f7312b307cd8bf25e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec39aea5cb6dba6858d0d313a469deeae7aba494ee9a635f5676be90b03772e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9ef552976841a096727deca6c1729b45f8d86fe1e38964f41a002fa69e0b47e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"railway", "completion")
  end

  test do
    output = shell_output("#{bin}railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}railway --version").strip
  end
end