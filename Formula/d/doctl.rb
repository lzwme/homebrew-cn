class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https:github.comdigitaloceandoctl"
  url "https:github.comdigitaloceandoctlarchiverefstagsv1.122.0.tar.gz"
  sha256 "7e354a8decfd0af30a357c5fec74ddaf9c792987c820424f8c663169dda82b69"
  license "Apache-2.0"
  head "https:github.comdigitaloceandoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b373aaa235ddd9219ba11f0b4ea4237e0160c4119a529c15e05d20cf021e962"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b373aaa235ddd9219ba11f0b4ea4237e0160c4119a529c15e05d20cf021e962"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b373aaa235ddd9219ba11f0b4ea4237e0160c4119a529c15e05d20cf021e962"
    sha256 cellar: :any_skip_relocation, sonoma:        "700c4047ae35c6d8d1090ac058ad09c7f593e636a725e9748f447a931a3b7fe8"
    sha256 cellar: :any_skip_relocation, ventura:       "700c4047ae35c6d8d1090ac058ad09c7f593e636a725e9748f447a931a3b7fe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8aa3fd3793e2a4341c8e2114677fddecf8d927803d0ecefc7f7db70d0472a045"
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