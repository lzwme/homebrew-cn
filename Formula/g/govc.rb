class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https:github.comvmwaregovmomitreemastergovc"
  url "https:github.comvmwaregovmomiarchiverefstagsv0.46.2.tar.gz"
  sha256 "4086b7de092932ad34be67b1a804c8d4f0e1664a1f4a99841034aad55d323f07"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e9d0f2b0b1c40bf60b3efd02be7c90eab44dbf499bef858717b2ee9ba5b3ba4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4aa8532091f140d7577e733f7fc7cccfd5cc16254df4a6113cfa65ee51e7a8c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1f0a77e43e69f6ee3692ca98cbcac41f377e63e0c682aa782a41d72a4b45c41"
    sha256 cellar: :any_skip_relocation, sonoma:        "69fc7c0b334e2054341279094634179148bed7736c176b7527d90b57e6a8ca6b"
    sha256 cellar: :any_skip_relocation, ventura:       "8b09d0815db4bf3e0841b16d417c19e4eb48cdfd1b63b1b347e58d3fab988d5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e17ba20919960b677a2a5ca3684baf7370a4c685a0befe43d07f11bc021b535"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}#{name}", ".#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}#{name} env -u=foo")
  end
end