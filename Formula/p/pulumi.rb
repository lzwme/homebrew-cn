class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.174.0",
      revision: "70245c2e69f863fb52cab1662fee31cab7c4e6aa"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fda114c2f38bb370ee31b9f7f6e5da7cf8608d3d616a57fa474357500089483a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a35ad7f2d489071b77253b42525c2bb993432d4cabd9f39e9819d488ad6f3673"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a889a698bb3ffa2cfd9c9654a93c528f4e59a57a7e180e9ea0aba95a84bca44"
    sha256 cellar: :any_skip_relocation, sonoma:        "e242be55dc367a369923508c02b7bdaace643a0d927f67d35d1e41703e5864ce"
    sha256 cellar: :any_skip_relocation, ventura:       "de4bde182364f7183345b3b597381eb8a46a1fc606e74626d2db99970a43a297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c0b3468315efaa21f356ac0f2d630fb48de5b8f87b7c32125831d27459c09d8"
  end

  depends_on "go" => :build

  def install
    cd ".sdk" do
      system "go", "mod", "download"
    end
    cd ".pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}binpulumi*"]

    # Install shell completions
    generate_completions_from_executable(bin"pulumi", "gen-completion")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local:"
    ENV["PULUMI_HOME"] = testpath
    ENV["PULUMI_TEMPLATE_PATH"] = testpath"templates"
    assert_match "invalid access token",
                 shell_output(bin"pulumi new aws-typescript --generate-only --force --yes 2>&1", 255)
  end
end