class Gut < Formula
  desc "Beginner friendly porcelain for git"
  homepage "https:gut-cli.dev"
  url "https:github.comjulien040gutarchiverefstags0.3.1.tar.gz"
  sha256 "6e9f8bed00dcdf6ccb605384cb3b46afea8ad16c8b4a823c0cc631f9e92a9535"
  license "MIT"
  head "https:github.comjulien040gut.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0286431f2fcf5c76d35ef9b12f7288b68ca2305d8792d8772a5af7edf51174af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a516511ac10156d192ef9b11a2fc5fd44eed5580eb5fd4aeb913e7fc56f65d45"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e093901851842d9b2316f7c9a409521b5e251c1d15547237a755c74afea70d1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "227d54c64f017833a47729813d0331b1b69af6355da3c84c08cb17a9c9f92e03"
    sha256 cellar: :any_skip_relocation, ventura:       "411974d0e89662faa21eb89f7f818f497550d06434ae101a7a6072b40046dc5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "975ad42fab24e3560a6c7b437dfa323004be12807e1013d83cf96f078e22ef13"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comjulien040gutsrctelemetry.gutVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"gut", "completion")
  end

  test do
    system bin"gut", "telemetry", "disable"

    assert_match version.to_s, shell_output("#{bin}gut --version")

    system "git", "init", "--initial-branch=main"
    system "git", "commit", "--allow-empty", "-m", "test"
    assert_match "on branch main", shell_output("#{bin}gut whereami")
  end
end