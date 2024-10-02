class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.72.tar.gz"
  sha256 "19f1879e75ede4afac8e6eb7ba735299d568369e2ec7fbd151ac56a1b2a99a5e"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "612e5bb9ec66532df6cd4f5dba3db1fb1b3e13efb38e6978fe174f8365602b0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fa295ee5d243912f2fc7c77459ce92dcf716035f9e51c33c458fa017236cb86"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da83fa51b2ab3ff8330de5c81f219d9ab42994e546118b98e73df8c624e60c58"
    sha256 cellar: :any_skip_relocation, sonoma:        "830b348566a8673c7abee65438d82044ed22c2628b339031ccf4756948221973"
    sha256 cellar: :any_skip_relocation, ventura:       "22f549fae8af74517557ce9b959a1f7adeb329d1283e0df008f8bb8b79a0cc6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b69b61b8984401febf35ae6f1f422a7aade760393b25d4fccae043ae2aa9eef1"
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
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end