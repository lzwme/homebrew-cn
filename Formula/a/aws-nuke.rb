class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/rebuy-de/aws-nuke"
  url "https://github.com/rebuy-de/aws-nuke.git",
      tag:      "v2.24.0",
      revision: "955a8f438918b33105f116c0bd3dc55feb5a6e1b"
  license "MIT"
  head "https://github.com/rebuy-de/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ae69e2cd373349bc988213d3d25a761b755b86ed8114ed876c74a1193f7d7b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ae69e2cd373349bc988213d3d25a761b755b86ed8114ed876c74a1193f7d7b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ae69e2cd373349bc988213d3d25a761b755b86ed8114ed876c74a1193f7d7b5"
    sha256 cellar: :any_skip_relocation, ventura:        "f1fd45265925715702d1e1a1f903021afecbe7e9f1788cf5806cfbaa20f1f7ab"
    sha256 cellar: :any_skip_relocation, monterey:       "f1fd45265925715702d1e1a1f903021afecbe7e9f1788cf5806cfbaa20f1f7ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1fd45265925715702d1e1a1f903021afecbe7e9f1788cf5806cfbaa20f1f7ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24b0a1da47ec78e891e074b1b48c0382805dae23915e63772c85e0f611f418c6"
  end

  depends_on "go" => :build

  def install
    build_xdst="github.com/rebuy-de/aws-nuke/v#{version.major}/cmd"
    ldflags = %W[
      -s -w
      -X #{build_xdst}.BuildVersion=#{version}
      -X #{build_xdst}.BuildDate=#{time.strftime("%F")}
      -X #{build_xdst}.BuildHash=#{Utils.git_head}
      -X #{build_xdst}.BuildEnvironment=#{tap.user}
    ]
    with_env(
      "CGO_ENABLED" => "0",
    ) do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    pkgshare.install "config"

    generate_completions_from_executable(bin/"aws-nuke", "completion")
  end

  test do
    assert_match "InvalidClientTokenId", shell_output(
      "#{bin}/aws-nuke --config #{pkgshare}/config/example.yaml --access-key-id fake --secret-access-key fake 2>&1",
      255,
    )
    assert_match "IAMUser", shell_output("#{bin}/aws-nuke resource-types")
  end
end