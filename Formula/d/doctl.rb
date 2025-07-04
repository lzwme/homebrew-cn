class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https:github.comdigitaloceandoctl"
  url "https:github.comdigitaloceandoctlarchiverefstagsv1.132.0.tar.gz"
  sha256 "6037dd2657b0b4cc27fed86808778cf86f8566ba655a5d04a31450416a975be4"
  license "Apache-2.0"
  head "https:github.comdigitaloceandoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f566a050902b70437e8547a7daddf9dd4838698bc5d244507dbcebb774a67b62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f566a050902b70437e8547a7daddf9dd4838698bc5d244507dbcebb774a67b62"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f566a050902b70437e8547a7daddf9dd4838698bc5d244507dbcebb774a67b62"
    sha256 cellar: :any_skip_relocation, sonoma:        "66c4825dd5d1dd3753e690b1392513d7d28f2ef3d723da2537ead70501b17423"
    sha256 cellar: :any_skip_relocation, ventura:       "66c4825dd5d1dd3753e690b1392513d7d28f2ef3d723da2537ead70501b17423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a09057a2823a58e9b815751c9cc52a105889e0d163eab12331f2c8674c0b9695"
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