class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.10.0.tar.gz"
  sha256 "7e596000a7ab4946592057cb26c26ac4965b8a7ccfad54e0e7fddfba58ece6ef"
  license "GPL-3.0-only"
  head "https:github.comcargo-binscargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed56ebc51411e576f5a08d3089c5c01663db69bf5c9bbcf063ca76e0632497cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c5999943d001ae80fa10369a08beb7308717a62b0450a2321b09f4bc3384742"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8564d4d478ed50381e1606b07a8b74d7f1aa9810357902b694bb07c4c4e67e28"
    sha256 cellar: :any_skip_relocation, sonoma:         "e32de48fbc92dc068aaff96614f6f64291716cd3c065ba87b65bb9871deb8af8"
    sha256 cellar: :any_skip_relocation, ventura:        "e0ceacc9937faff7e9fac85e4ac4c211f65bcbb811b9c6aefe36b9771ace1144"
    sha256 cellar: :any_skip_relocation, monterey:       "0f8a8a5d038676de2e52145da9976b402383c60c77139a0b6bba40eb75ae9300"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d30a3d808eb0c1f956ab126e168ad6a3917dfe648d5d40d72ca77efb4c7a0455"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratesbin")
  end

  test do
    output = shell_output("#{bin}cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}cargo-binstall -V").chomp
  end
end