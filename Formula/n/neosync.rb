class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.5.4.tar.gz"
  sha256 "ea000359bc19f949b66ac49fecb6dfdec469ec21e605ea488497b3aaf0adf17f"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee12ed4168506868ab06e51ad531d896fe21068911964207e7773865c8cbeddf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee12ed4168506868ab06e51ad531d896fe21068911964207e7773865c8cbeddf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee12ed4168506868ab06e51ad531d896fe21068911964207e7773865c8cbeddf"
    sha256 cellar: :any_skip_relocation, sonoma:        "47f21f0bb4dbe5e0f000a62e320050ca9d18b3b8fe080733c779e5b5a37204da"
    sha256 cellar: :any_skip_relocation, ventura:       "47f21f0bb4dbe5e0f000a62e320050ca9d18b3b8fe080733c779e5b5a37204da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "076e89423700c8f9a90b7771282c9656370684fc77553e16438cc95582522ce6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".clicmdneosync"

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end