class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.5.21.tar.gz"
  sha256 "a6e19daeaf1bb3794b8d9cf0117359395c50745e14e03d5f91c0ae8bb3dfb138"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a69453b78e28fb99be845276ffd9ac166b593448df61b987366592abc2760e9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a69453b78e28fb99be845276ffd9ac166b593448df61b987366592abc2760e9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a69453b78e28fb99be845276ffd9ac166b593448df61b987366592abc2760e9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5855f9695b7858ddcb3a2d3070001a6697ad94b0cf87542424f0625c58e5e921"
    sha256 cellar: :any_skip_relocation, ventura:       "5855f9695b7858ddcb3a2d3070001a6697ad94b0cf87542424f0625c58e5e921"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3240669e6f0a637e5f39ecb46f7cad3b9964b813960beffc2dc63655a78a3a3"
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