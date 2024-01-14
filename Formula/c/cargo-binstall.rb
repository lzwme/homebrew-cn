class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.6.0.tar.gz"
  sha256 "325e5de273f7f6f9e0885495611a46cf07fbb1d5396a373e418e4c623a417c2d"
  license "GPL-3.0-only"
  head "https:github.comcargo-binscargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02eff083e6af3117ff268dca32ca07c7551243ed0062919e802c8d4fb75f8cfb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1bd2918c5ea4604dac63b846edfde375659d713ee682337dc2ca2e7e5e23b4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0675c7a544a3507a2be1725962ae2bca9170bb5d740c3b5506013e50f7dc5aac"
    sha256 cellar: :any_skip_relocation, sonoma:         "7161a3dd3ce748938af19ed770309c22563d9c419da9adba464cd3c04eb5afe0"
    sha256 cellar: :any_skip_relocation, ventura:        "496d4470366d9ee4e77ed43b8e13da7ec24f96146797c7fa654334047c518e65"
    sha256 cellar: :any_skip_relocation, monterey:       "107ea89d5ea100b8919679022a02070f5992056acce158b9dde7e35effe141bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3f73a7ebbd6f652a4c48cd3f3c10b402e628907da562cfb134f517a71ef2c50"
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