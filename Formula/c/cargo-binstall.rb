class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.7.3.tar.gz"
  sha256 "66065f4d2202d531753b9511004b55ba50bd28dd8f86630929982d75bedff7ac"
  license "GPL-3.0-only"
  head "https:github.comcargo-binscargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25b7748e2f3989eba37964796b1905c84f1558d4f96a606be97c278460670293"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7a6800934083d5c9bdc0bbe26319d78b78b5391ea1c394d2277d4efcb1ef208"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2bd908313375da251d5a312ea2d514c4b110239de8791a9751edd0767381783"
    sha256 cellar: :any_skip_relocation, sonoma:         "11246ac0c5b2186fb46e4c239e21e09742b78bd8d914d327662d6836714b6903"
    sha256 cellar: :any_skip_relocation, ventura:        "b2a81791a74967be49db6cdb3be4180cac2244c497944368dd5d5987de3cbad5"
    sha256 cellar: :any_skip_relocation, monterey:       "12e60091a2519dd4276fde3ee4b36d92f104222c8051d7c310e0e3e2dbe97d65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcf4d447f9f37e011b37e376b083983f1847e6b2bdbe596813ab54ac02505bc6"
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