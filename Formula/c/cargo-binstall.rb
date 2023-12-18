class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.4.8.tar.gz"
  sha256 "4e532d895da8a661dcc6b694a24b02b5ee2ac5bdb955e5253b1ea7896f46490b"
  license "GPL-3.0-only"
  head "https:github.comcargo-binscargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bce25bdd23454c07f3a80aa9eb17814569137b7abcf67d94cbb1b4fa2749b37b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "886dfd2a14310741962122c1c413d3973e83612e68b0db1901b241ee0fac8513"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1609d7730c146f74f56c426e20b7cf4a4f1c7af6f47be6894545f0ddff2db821"
    sha256 cellar: :any_skip_relocation, sonoma:         "def667fe55c6810ae84f980c80a63ad0ea667a972fe21a11db3b6515c59d067b"
    sha256 cellar: :any_skip_relocation, ventura:        "a98661a3e12d4e9f0df57ab57cea69aee3f5be827dac6e48410111d2d98b9948"
    sha256 cellar: :any_skip_relocation, monterey:       "26bf48351ba9e1c238202ab8295217d109f2391410b55f211f903db1df9f608a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "850ca44d855fc12daca168acd0c7d1ca88d83747a7f8d4abdb4640fbdb6b4745"
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