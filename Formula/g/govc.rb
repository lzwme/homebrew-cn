class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https:github.comvmwaregovmomitreemastergovc"
  url "https:github.comvmwaregovmomiarchiverefstagsv0.45.0.tar.gz"
  sha256 "02de33215086100002b204688685ab81961bdd0f583404c49c8c759fffd7eef5"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc1956e67a51e7defd26e3557e5b3ac78ad6f4499bcaf1cfa3e78b89a35393c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0cf12974e6bf2ab1018291c675d89d6f88b0fbd0f3dbec12296b673ea46df8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c8797af4339d1d39a5a90294d0043eecdc1f71b5f2645b26a5b7f79725639cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "22a047d4152933fd613da27872658e729a82a64a5ae45afe569788cae597226f"
    sha256 cellar: :any_skip_relocation, ventura:       "7e727c0b0c3f1018bd21995324615f788a497d9ca51a60e9fd272610364913a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93960ab0ea79ca309ceedbfd8ea9a4555fbad13c63f9d0d1b061658162ed5e63"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}#{name}", ".#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}#{name} env -u=foo")
  end
end