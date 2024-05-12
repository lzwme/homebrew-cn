class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.6.6.tar.gz"
  sha256 "dbe537b89f381ac7a1c8149c3efae3b18bb1ca76fa9dd364125c4c1f29acc6f8"
  license "GPL-3.0-only"
  head "https:github.comcargo-binscargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbd8b3134a36f19bcebfcb5bfbded5983de9e03e27ccada0ab40493bfba7c2c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16719e0ef57dbd91779635e4f402b6940017c6af5472156380e37e5ada3c82e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa64804c0cf27402e2b3dc0fa0566ac4615a5a2fa7badf8e478131e990cf7995"
    sha256 cellar: :any_skip_relocation, sonoma:         "baa6a87ba8fb3c3c1fb9948b0b819ec9b10e6faea437c9b775b6aff2423bf92f"
    sha256 cellar: :any_skip_relocation, ventura:        "518f91535eae645468560ad217c71b243e795a673217e5c74114b51f79ba0159"
    sha256 cellar: :any_skip_relocation, monterey:       "5a713da8f7c16a6b62a735e9ecf9ca8bbee7651457b7af109c96e71d943390aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "921eb091ac35bff19401ac27ea733fe8028e532f7b191591cc7964fb9257a5c9"
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