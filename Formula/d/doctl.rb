class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https:github.comdigitaloceandoctl"
  url "https:github.comdigitaloceandoctlarchiverefstagsv1.125.0.tar.gz"
  sha256 "a46bddd41ccc3aef4d06a00140273af3bdf66e4d851b034b3315774491df55c1"
  license "Apache-2.0"
  head "https:github.comdigitaloceandoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6acb07b5fb1c49d6966d39a931d8efd1a3325351c55c51c13dfb4659ce2e570"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6acb07b5fb1c49d6966d39a931d8efd1a3325351c55c51c13dfb4659ce2e570"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d6acb07b5fb1c49d6966d39a931d8efd1a3325351c55c51c13dfb4659ce2e570"
    sha256 cellar: :any_skip_relocation, sonoma:        "7079186c58b8157036600f883400ef46306f37bdc3b53a11894d5742b15de013"
    sha256 cellar: :any_skip_relocation, ventura:       "7079186c58b8157036600f883400ef46306f37bdc3b53a11894d5742b15de013"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "debf07961cfab9eeea1ed741b1e3c478b9f6620c50358dd2e0248ebdb955f3a1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comdigitaloceandoctl.Major=#{version.major}
      -X github.comdigitaloceandoctl.Minor=#{version.minor}
      -X github.comdigitaloceandoctl.Patch=#{version.patch}
      -X github.comdigitaloceandoctl.Label=release
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmddoctl"

    generate_completions_from_executable(bin"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}doctl version")
  end
end