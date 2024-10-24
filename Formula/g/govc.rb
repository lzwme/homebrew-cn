class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https:github.comvmwaregovmomitreemastergovc"
  url "https:github.comvmwaregovmomiarchiverefstagsv0.45.1.tar.gz"
  sha256 "37077b5534f3ade75bc766a492d2c24901a0fd65cde6208d1a5e7b3cc6c02088"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad3323262af1414df5d47be771ea57744fbf92f8c89f45ab59854e0d813ea4dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3bec9cfc5f56514729de68d69e69d24ce82edb042cb94cd3af97f87e0c0df4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4108244f2de644e31186216b9c6740d33d1175c7fac9210b1e0f56992130b0c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f85d621d7314b711ce4705e4e2c73fbe8aff31459c144a094dd78e31964aa841"
    sha256 cellar: :any_skip_relocation, ventura:       "edc2ea61c9b5c91f5eb2173e3a3200dadfbbfd4a9cc2b89cb404a1f6a6d21ea5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a4062a1ac122ac843843313b651636ab81f4397bc513c55e7af1ce7ff3b65f9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}#{name}", ".#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}#{name} env -u=foo")
  end
end