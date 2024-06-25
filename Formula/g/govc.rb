class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https:github.comvmwaregovmomitreemastergovc"
  url "https:github.comvmwaregovmomiarchiverefstagsv0.38.0.tar.gz"
  sha256 "a85bc3e1efbc765eb91a4955a9500961b363ef8b928a417921815e48bd18065c"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c5e7325a46162d582976089975d6921ec0bcefaa0bdada40c072f7727761f92"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95d9e5b2eb2de47d4ffe331509e7ae2aaac705935e7d7eb1b4a3ceed535c7c67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d67e39669f056306980e0b8d4aafe530bd4eee5d8851ccd19ccb557e52ffd89c"
    sha256 cellar: :any_skip_relocation, sonoma:         "75a06e115e2d8ced3ac6d0afe545f7dfd3fdb9aa516e8e47cba6863fabaee4ca"
    sha256 cellar: :any_skip_relocation, ventura:        "3f746a73b8af10089e1014313d1900b764a208c32b95ddc5f170a04518e66e41"
    sha256 cellar: :any_skip_relocation, monterey:       "5e137549e37354b983a8868817246d5180d2019f22138457518afb2bbabba90d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "892b889bedbb2eab681517ab50831b0becc3c5bb10cb0503703f19ec54fa9489"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}#{name}", ".#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}#{name} env -u=foo")
  end
end