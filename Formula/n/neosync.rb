class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.87.tar.gz"
  sha256 "eb59d9342792ceb6895653f9712da43f4ec3ab98eb2eeb6d2a6ffa3a83573673"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a96f5279516cce8210dacb965cf34e32ec09d81a499d949d69d1a14bd447f8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a96f5279516cce8210dacb965cf34e32ec09d81a499d949d69d1a14bd447f8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a96f5279516cce8210dacb965cf34e32ec09d81a499d949d69d1a14bd447f8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fa1fca4b166602ad0842ffda400deb4c8fa8700e6b6ee830696b7b9944efa46"
    sha256 cellar: :any_skip_relocation, ventura:       "2fa1fca4b166602ad0842ffda400deb4c8fa8700e6b6ee830696b7b9944efa46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c788dd9c54483672b9309143d72f6c150c4fe678137d7e31cbaf5cdef16a3dd"
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