class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.98.tar.gz"
  sha256 "1e8a74ed97f2e73c1282c33be05f2b036b8d804a0ca9a7a56a0d50b66176fa94"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee8c11c02b4057dca06de1db448ccb5250aaf10f48247f06a3d709117ab7808a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee8c11c02b4057dca06de1db448ccb5250aaf10f48247f06a3d709117ab7808a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee8c11c02b4057dca06de1db448ccb5250aaf10f48247f06a3d709117ab7808a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e697ebaff00007e7bb2f24afb16740e326c0412c5785ddeeae7b846a879f8b1"
    sha256 cellar: :any_skip_relocation, ventura:       "7e697ebaff00007e7bb2f24afb16740e326c0412c5785ddeeae7b846a879f8b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b9025527ac1e9ff582882e94e6d668788a19b7de20bf7d756d938b095744d4c"
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