class Bomber < Formula
  desc "Scans Software Bill of Materials for security vulnerabilities"
  homepage "https://github.com/devops-kung-fu/bomber"
  url "https://ghproxy.com/https://github.com/devops-kung-fu/bomber/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "4f3c66204b776c8a87a8ad48f9ed87d756164c890e03ce2aa0e217d809c3ff0e"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5356b1834ac935fa3be39989da3ad5387626eac16bd881bc5d5ced5709f34d2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16b326862f5d06a27764e875b0911eb728bdeb13a68ae99ad8b6a6f967bb1adc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06a32a3812cb05a636b39ccafbc2987968c503aa8b2a9b952f3703a0bbf86e9b"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b7d8b7fb7a6d524b3548515263642f600bb839092dd326743932113ea5733b3"
    sha256 cellar: :any_skip_relocation, ventura:        "ab2fb647e5eab91053174fe4ef855aef649cbb4ae4a449df083581a3394bb9c0"
    sha256 cellar: :any_skip_relocation, monterey:       "ef6b4b85784cff668f1f99418fde2bc0ff7021c2dcfacf1a39321d46ee64e0b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ca7c8b75e336704de0a784ff010c7488485cea784ed59cc6401c57e5e9445db"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"bomber", "completion")

    pkgshare.install "_TESTDATA_"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bomber --version")

    cp pkgshare/"_TESTDATA_/sbom/bomber.spdx.json", testpath
    output = shell_output("#{bin}/bomber scan bomber.spdx.json")
    assert_match "Total vulnerabilities found:", output
  end
end