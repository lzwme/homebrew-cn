class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https:github.comdigitaloceandoctl"
  url "https:github.comdigitaloceandoctlarchiverefstagsv1.127.0.tar.gz"
  sha256 "f63b1bd3eb693b6f376dd38b478339bb4f315653dc6f27fb09345da9d803d811"
  license "Apache-2.0"
  head "https:github.comdigitaloceandoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7886b4cc6d042fc9fc6737b2d381ab3704d39eacd2670cdd8d3fd7b7a8291865"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7886b4cc6d042fc9fc6737b2d381ab3704d39eacd2670cdd8d3fd7b7a8291865"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7886b4cc6d042fc9fc6737b2d381ab3704d39eacd2670cdd8d3fd7b7a8291865"
    sha256 cellar: :any_skip_relocation, sonoma:        "56ae65fe9dd48187179af23c0d187082708983eb6bb95338ed445c01b591ee4a"
    sha256 cellar: :any_skip_relocation, ventura:       "56ae65fe9dd48187179af23c0d187082708983eb6bb95338ed445c01b591ee4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4af8170b07a735b07d3aeded371a14463aad9ee58dcef10e636e87a02318eab"
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