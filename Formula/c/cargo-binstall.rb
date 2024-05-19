class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.6.7.tar.gz"
  sha256 "ceb68979fa6a37af668969e26ed20acf5c9b7eac856a90911805cd7d35c8811b"
  license "GPL-3.0-only"
  head "https:github.comcargo-binscargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6669e7d95d2e86af3683b71e0f98c7d3327edb6ce483e94cfbeadf2c29c36681"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd6524b75f69ba0cbf8121598f002cb0a898828372e2e6bd608b688535ded8b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7ad1821cf0e63b3f87bd48cdd3e1bf6b5a813fba24a4e3c7377692e6f22ba6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "7fa839f68712ae6a5975f90d1c46a0dc8c63b531a35a60ba413bd55a4bf15fb8"
    sha256 cellar: :any_skip_relocation, ventura:        "fcf5bcff65ba575e7867d34a51b4e38093f1075a3da00472e792a0ea2bf482f3"
    sha256 cellar: :any_skip_relocation, monterey:       "e8c68f3bde29db0d8faf2297b78331ff1cacded08bc592e8b78402eb1e28d38e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a8693f8e37c31600d88be182ac09f8720069af1f1b9c082027f578766a71ede"
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