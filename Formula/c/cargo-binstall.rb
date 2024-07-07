class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.7.4.tar.gz"
  sha256 "99d24b9146b130aa2d937427a6d11ef2c6431aa7444583bca62baa2ff41802f4"
  license "GPL-3.0-only"
  head "https:github.comcargo-binscargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f203b4a16b833812fc16d1ba5b882315785865dc42b855295265e1fae17f5b77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd1fa9f588dd27a85f431ede11a8a25ef9f20940df463605ce09aafc0cd5df69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59a78e9afeba605bd8103dc472677b41ce063e1985573a1f97a90b1af46a90b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "5969740c9d48b19271796b74193dc51082453c5bf8fa3d8ff5c1375cc0ea1a75"
    sha256 cellar: :any_skip_relocation, ventura:        "4009d851f4432e2a096d2262659b960fdf000268214b2bb2757e9e032ea800c9"
    sha256 cellar: :any_skip_relocation, monterey:       "576c4e63f677a8d19a2f4caa68a3b96950b7b7bd106ddfdce6d3d93b2cb5ac79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ee41c1a608ceb95717651343c5b56680c461a18c6e8092e880566693cb72d68"
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