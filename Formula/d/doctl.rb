class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https:github.comdigitaloceandoctl"
  url "https:github.comdigitaloceandoctlarchiverefstagsv1.120.1.tar.gz"
  sha256 "810a2165ba9d7cd1f3fdbe1393c13e64a2068bd1f317753347bc801110b2b182"
  license "Apache-2.0"
  head "https:github.comdigitaloceandoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0e5bc0d02e0e5b68f6fe8e4f735394e173d6b5ea5256b4cb15bd767232757b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0e5bc0d02e0e5b68f6fe8e4f735394e173d6b5ea5256b4cb15bd767232757b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a0e5bc0d02e0e5b68f6fe8e4f735394e173d6b5ea5256b4cb15bd767232757b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "99b9265d39a05bf82300569b79564d9c36078040a6d2e7213ae374e214f2a33f"
    sha256 cellar: :any_skip_relocation, ventura:       "99b9265d39a05bf82300569b79564d9c36078040a6d2e7213ae374e214f2a33f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "565ce82c1d1855382c4fda430268870a42400c9eec3facff2e6dbf2c5d58b514"
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