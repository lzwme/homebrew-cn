class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https:railway.app"
  url "https:github.comrailwayappcliarchiverefstagsv3.20.1.tar.gz"
  sha256 "4c9c9b0b44acb503962e89b45bcd6f815ca90d76648a88eb0896aa45260a9379"
  license "MIT"
  head "https:github.comrailwayappcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0a2daced5050453b7f24abd3cbfc832689135a59e5c5c0b4e30c1b858940859"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffd50710999051640040e031b3bde2effa9ba92c175bd0f45723950bf247d32d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c4c60c7dcfc0e18688479d83dcd62c28483ad525415acde3743359fdb269591"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a291d1058138166133431270c585d5eae20b4956ad197b7e667d52ff2c26112"
    sha256 cellar: :any_skip_relocation, ventura:       "7b9936353fcd7ac39771e74661830a0ba9ae729fdce8d4d56101825f66f2cff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8732f362df2ce19cfd8935540a6803e11e63140ee5d137c04742371363f452b4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"railway", "completion")
  end

  test do
    output = shell_output("#{bin}railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}railway --version").chomp
  end
end