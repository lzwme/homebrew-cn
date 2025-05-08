class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https:railway.com"
  url "https:github.comrailwayappcliarchiverefstagsv4.4.0.tar.gz"
  sha256 "b8879601028e9922491f9bcf56f53837d19be655ffa0fd88eb090f3d1b1b3e06"
  license "MIT"
  head "https:github.comrailwayappcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72222923f92283a386248aff68e5f5abd8ac44b89a622ed78ffda7b2e9228f46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc308f449b00ca6975ee3d7aec5a27bfa4201126dfec154ba3ddbf13af349a6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f2cdbcdbff1a374e1f44ce5be2fedbc0554811b64061ad1ff99becb91be9c5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "38db0a107fc460ccf8c7eae0b13f4b1045cd5c19b25090d6904afdb194303107"
    sha256 cellar: :any_skip_relocation, ventura:       "50c3013b7f2e97b28cc72a7ae44649f267cc41a72c7da19c8bf36490ca978d77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "020a585c5000ed69e771a9d8d2ee0e07a7ce3e845f0df72fbc7c025026305c91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2268a935a70b57a4e9c639e0ddab32b33df9714f585bf1b0c45bd1bf5df3729e"
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