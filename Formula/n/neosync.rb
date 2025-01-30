class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.5.12.tar.gz"
  sha256 "facfbcf9ed9bd1765c5030c52bf2cd17c1c2acd85ecc56672b2832ccb660c97e"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3859cd81aba45a7925828c8addcd4fcda086d3054c760fac38c56adbc74535ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3859cd81aba45a7925828c8addcd4fcda086d3054c760fac38c56adbc74535ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3859cd81aba45a7925828c8addcd4fcda086d3054c760fac38c56adbc74535ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "da66c8c2d242d903c965f49284199763ba67974e487b5e44fe4f157e0088ac2b"
    sha256 cellar: :any_skip_relocation, ventura:       "da66c8c2d242d903c965f49284199763ba67974e487b5e44fe4f157e0088ac2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64ee7dfb840cb058fa5ba7b73a9d7f2a34da484d081a6c1de4c62ba709c55624"
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