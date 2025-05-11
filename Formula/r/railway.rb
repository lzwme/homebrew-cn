class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https:railway.com"
  url "https:github.comrailwayappcliarchiverefstagsv4.5.0.tar.gz"
  sha256 "0a7e9fb04970795e23e80a68dde355021aaff9146b0a376840ff7d065920a0c4"
  license "MIT"
  head "https:github.comrailwayappcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b640104ac2d1daab637cc0262651e900f2bec88b41cbc3243008a41edf99238d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbe8c77a87f7d922343e23394aa4d5ce2b776ab265add39880ac74c59d639337"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e09df544c27541d772402a08b4ae02de4f1e71c21eb99ac685d8e223d7c4b58"
    sha256 cellar: :any_skip_relocation, sonoma:        "318feba4c426347f56421bffe03e12d925005fe4ad66db5770996a3dc8deec91"
    sha256 cellar: :any_skip_relocation, ventura:       "08712f861c14ca8a7641d2bf488df48fd9ee06b0bce228839e5a60299e3137ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c623516ec34414568d2064e79894961188866de007fd41d00389fa635e083692"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58d29137244121c3a41f61133472aaf62a76aa3bba25bd6a45675265e68aea49"
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