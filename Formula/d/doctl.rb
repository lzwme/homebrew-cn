class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https:github.comdigitaloceandoctl"
  url "https:github.comdigitaloceandoctlarchiverefstagsv1.120.0.tar.gz"
  sha256 "d0add17d40ac13c88b30aa27524d8a168bcaef44af6e627f21ff8179226cf685"
  license "Apache-2.0"
  head "https:github.comdigitaloceandoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47c4646f68519b0c99b26c382a012e5bdb78b7be26a691b38f148e65148c4976"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47c4646f68519b0c99b26c382a012e5bdb78b7be26a691b38f148e65148c4976"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "47c4646f68519b0c99b26c382a012e5bdb78b7be26a691b38f148e65148c4976"
    sha256 cellar: :any_skip_relocation, sonoma:        "79494f00676093b8f6137823d7abf5c80ac764471023862da49f5d074a9daa65"
    sha256 cellar: :any_skip_relocation, ventura:       "79494f00676093b8f6137823d7abf5c80ac764471023862da49f5d074a9daa65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f104ff976bf5b95c020cf4c4bb80e7d63d890b4fb8db7c2963b67a3f7e8e65d2"
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