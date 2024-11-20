class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.89.tar.gz"
  sha256 "8a4c8669713be7bf7450fc4fe52ae45ba6f79a6ccff9f8c9291c0e3ba7d259d7"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a63e96b4b71852f664cabdbff4b39538597fbcc24803d614d4385a0cf163bbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a63e96b4b71852f664cabdbff4b39538597fbcc24803d614d4385a0cf163bbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a63e96b4b71852f664cabdbff4b39538597fbcc24803d614d4385a0cf163bbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "4213f28e2f957a674100f94789c1655d6d7d74b968c31e87b6d6ef82abb33e13"
    sha256 cellar: :any_skip_relocation, ventura:       "4213f28e2f957a674100f94789c1655d6d7d74b968c31e87b6d6ef82abb33e13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72949f16e9805ccc9ff3bcae3be7213989f33be49d269da9b232ff6678aca442"
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