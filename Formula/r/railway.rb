class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https:railway.com"
  url "https:github.comrailwayappcliarchiverefstagsv3.23.0.tar.gz"
  sha256 "4e3855b32188478217f75c1095d5eda665433e323c2a3220322d80a890bb8d01"
  license "MIT"
  head "https:github.comrailwayappcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4f8fc73450aa54cc9969c04a8ecf0d8a2d6891087e679e8aced5ad127825b5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4afca56933be1cad3d539c24b4f28f569850ae589feb7d8e266b35abfeedc2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c2e08ccc06eb70c1b7aa811cc639f27b9b528a7a6eacf95b5340568ca29e8b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d3abd30ef6ddbb34990e7724f1251f1d21c2d8b33b8c0b8c352c0042c19aeed"
    sha256 cellar: :any_skip_relocation, ventura:       "dec10eeb53af432f633b606aa2eb44789fea14b70ca947cbaf3b16a9c8cf490c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a01211adf1374e3c37b87194c52ccd0d0eab90a93fd31913776018d04a3307c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a85502fd9e3bb64cb6770c3807dd8a4561eceb35054f122cbafbf182eb92884"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"railway", "completion")
  end

  test do
    output = shell_output("#{bin}railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}railway --version").strip
  end
end