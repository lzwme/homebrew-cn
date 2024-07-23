class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https:github.comvmwaregovmomitreemastergovc"
  url "https:github.comvmwaregovmomiarchiverefstagsv0.39.0.tar.gz"
  sha256 "6127eb16bab12e9a81536bd3a7d0f30d79368e677a6dfe517dffcfe673343bb2"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2fe2837a2b2c53e08ec9dcdf040046d4a0c9668e2dd16690211932ecdbf3c5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ebcf8029be0d90fb7ee77a30ea5f01c410bec7e0d90780530eea597e74fa972"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b4e1b07c31b346faa4ddd9f63496b05546ac140c405a82a2194d6219e16e1c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "628ed2a4c9b4f47bbfa37393760186efe5ff9d0447a26d6687b1f1edfea655e6"
    sha256 cellar: :any_skip_relocation, ventura:        "57b803f6913753581b43a21af9e03c0f081b3f380e712a84159d5383cb75962b"
    sha256 cellar: :any_skip_relocation, monterey:       "80b919ff869cac54e2fad311fd02d76fcb5f9cfd6bdd78dcf364d2a0352b5f21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa63e5a0bd14200938050f145c197fd62c0af62b353d2ef53a28e681f69fe9ff"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}#{name}", ".#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}#{name} env -u=foo")
  end
end