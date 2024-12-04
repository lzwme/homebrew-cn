class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https:github.comdigitaloceandoctl"
  url "https:github.comdigitaloceandoctlarchiverefstagsv1.119.1.tar.gz"
  sha256 "ff1f5a0a2cca9a4adf36d70f7a0dd43e9345fc8caed7692355fd7381ef01f914"
  license "Apache-2.0"
  head "https:github.comdigitaloceandoctl.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efa80baa4208855f71d4eb70a4109a6fae617dcd7b5de2d4d038d8bd65faa623"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efa80baa4208855f71d4eb70a4109a6fae617dcd7b5de2d4d038d8bd65faa623"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "efa80baa4208855f71d4eb70a4109a6fae617dcd7b5de2d4d038d8bd65faa623"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd44e5bbe490c336be302c23ec41e7b91fd135bbc9f51e11ca4b4bee9d4c577c"
    sha256 cellar: :any_skip_relocation, ventura:       "fd44e5bbe490c336be302c23ec41e7b91fd135bbc9f51e11ca4b4bee9d4c577c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "770a510d6dc710fa68c280de7ffb5d63e649c65da752241e26503832943a8c11"
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