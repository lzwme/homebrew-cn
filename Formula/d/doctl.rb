class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https:github.comdigitaloceandoctl"
  url "https:github.comdigitaloceandoctlarchiverefstagsv1.130.0.tar.gz"
  sha256 "6fea58bab84cc10fc07cc676590c0c35459d8fbc5d7b4c8ad39e984795485b4e"
  license "Apache-2.0"
  head "https:github.comdigitaloceandoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d088cc2b78fbdd00f18a95960bdaf0ad905587dd4fd90b8a7607500a944434c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d088cc2b78fbdd00f18a95960bdaf0ad905587dd4fd90b8a7607500a944434c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d088cc2b78fbdd00f18a95960bdaf0ad905587dd4fd90b8a7607500a944434c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "49822a4b15157caabdc5354ca61a5f331dbe917037a9b8bfefa5dff15e4b6714"
    sha256 cellar: :any_skip_relocation, ventura:       "49822a4b15157caabdc5354ca61a5f331dbe917037a9b8bfefa5dff15e4b6714"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a84403184ab77232b9f1f0c7d66b6540d6016e27ce3cca61f6fe73e064c963bf"
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