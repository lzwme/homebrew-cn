class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.99.tar.gz"
  sha256 "eb58fefd989b0c29d86e4687d66cd7fd8c027b90271ca018bc870d03834f12bf"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7112cc71d7bdee6974f9dc717bf03bbdeb00ab916dd4a75ab322b7f558da4b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7112cc71d7bdee6974f9dc717bf03bbdeb00ab916dd4a75ab322b7f558da4b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7112cc71d7bdee6974f9dc717bf03bbdeb00ab916dd4a75ab322b7f558da4b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d885fc3570cf0a0e85bbc73dd2566e2dad79e62ba6ba4ee07e08a83eae87ce9b"
    sha256 cellar: :any_skip_relocation, ventura:       "d885fc3570cf0a0e85bbc73dd2566e2dad79e62ba6ba4ee07e08a83eae87ce9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d2305d0b4443454157cdd794e410489efb8a696892374166a64c30117311f42"
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