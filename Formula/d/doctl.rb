class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https:github.comdigitaloceandoctl"
  url "https:github.comdigitaloceandoctlarchiverefstagsv1.126.0.tar.gz"
  sha256 "13fe74dd886418c6731bb55427f89bd904e3692f9280f3668ee5fa5000783be0"
  license "Apache-2.0"
  head "https:github.comdigitaloceandoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1f9b7fec821afb4ac937afbdfe6fcb44d9a425ced63e899c5140bce2a9ac8b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1f9b7fec821afb4ac937afbdfe6fcb44d9a425ced63e899c5140bce2a9ac8b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b1f9b7fec821afb4ac937afbdfe6fcb44d9a425ced63e899c5140bce2a9ac8b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "45867fa35a1bcd50bb29661a7a62c5c452b8413d6a754a1318d7775366376111"
    sha256 cellar: :any_skip_relocation, ventura:       "45867fa35a1bcd50bb29661a7a62c5c452b8413d6a754a1318d7775366376111"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "780c1ce0842592f7c34fef07e836866ba00787d9f3f7d963d93dc0f864c5542c"
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