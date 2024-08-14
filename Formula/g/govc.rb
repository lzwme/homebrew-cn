class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https:github.comvmwaregovmomitreemastergovc"
  url "https:github.comvmwaregovmomiarchiverefstagsv0.40.0.tar.gz"
  sha256 "548487d29e65b16e7a706f7911ffd46d71bfe16d406fdb925d8887329bd0a0c9"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a575f350c63efccad16652d01030d690e7254d279eaa7140ea894ac3450e9cea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f703dda8eb64c4e54a0532b36dff7b8bc8dba8d14d9a2737a505e262a2b04ce9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6249318984f88f004ad6c889f2442050b67661ea946e0a55e597c5a41ba9031a"
    sha256 cellar: :any_skip_relocation, sonoma:         "96aad1bcbe85d21da62ad6e2341b25703f4b76fca616cd3688c57614cc395a16"
    sha256 cellar: :any_skip_relocation, ventura:        "72f5b9294f5a2e44c6b8b752ac0f5e74610a751c8c2f81fe70c97a6dc2d76a66"
    sha256 cellar: :any_skip_relocation, monterey:       "835d6916e82fc58fac79d7352cfc45994b76e52062978a4877680b2fd0c32318"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa0fe0087313b96a96d21d253b18033dea15baa3a9c543daa0e4efec26d229c9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}#{name}", ".#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}#{name} env -u=foo")
  end
end