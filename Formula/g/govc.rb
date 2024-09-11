class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https:github.comvmwaregovmomitreemastergovc"
  url "https:github.comvmwaregovmomiarchiverefstagsv0.43.0.tar.gz"
  sha256 "9eb27e89b1ca8b0b9dce722b27c7c95a731f30634c63959d5f4dae0b7d400dd0"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4abfec28c22fe0a4d6ab32a35673c1c0d6930b5b1f3842200d3e5d8438e0018"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24962f279d00fa2f13e9d9c9fc3d444856ca992888ebbb50649c227967d57b09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2fcd8f59ba10d734115d2f9dd7846e2eb75920b2f27d4a53a4d544aeed83e57"
    sha256 cellar: :any_skip_relocation, sonoma:         "49532948ca8a3bde8b163232269610c5a542cd56042b2c3cf4ba2fe2e3d934b8"
    sha256 cellar: :any_skip_relocation, ventura:        "b6545182658a1de12633bf3a757125ac7d3edb01fb9f25ffef27394bc7449dd0"
    sha256 cellar: :any_skip_relocation, monterey:       "2bcac392876cca83b94a60b9d7736fb47116aca9acf257f3dd8a38c059b50091"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9052eda4369c8a26926261a081b5c7fed9faef50f037e42e1ff38e604e9b2b35"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}#{name}", ".#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}#{name} env -u=foo")
  end
end