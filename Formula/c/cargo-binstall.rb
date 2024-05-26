class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.6.8.tar.gz"
  sha256 "5641129239d1aca50e050ccd70d4712ab57e7cfe0d00882d7fc07ae52fdfa3bc"
  license "GPL-3.0-only"
  head "https:github.comcargo-binscargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3d9ff8148d5e188240ce231f77fd28f6821d43aee6f52c42293f0d9de58ec45"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2050321c17914c1723c40f0a0db570482d77cb46f1eaf48ea92a1f1ecbce8895"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2a95e706ba8ff94395be21001b4e3332b67fc00a8f28dde0316d593d5b4e377"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e2605629c9d2f49ae568ce50d9bfe5d1be2afee2bfab0f944ec59f65b7565fb"
    sha256 cellar: :any_skip_relocation, ventura:        "0175fb02f2defd2b22b20c0de9d9c102a8bb54344d8f038287eeb0dc57a2870f"
    sha256 cellar: :any_skip_relocation, monterey:       "77882dbf0a1d8b86f3225929641d6d82829dac6e560d603524cb81d3244599d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d6e43bba5655c6d63f4c747662359cf65724a26e8a96c1adc3cd5e5411ab56d"
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