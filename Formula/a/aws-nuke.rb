class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/rebuy-de/aws-nuke"
  url "https://github.com/rebuy-de/aws-nuke.git",
      tag:      "v2.24.2",
      revision: "158ca368c02ea0ffed86b255eab81e438a856edf"
  license "MIT"
  head "https://github.com/rebuy-de/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c698055560a60c51ee4c5c9abe4bdbd59bc9e1dd95ecf94353e29c4e55ea119"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c698055560a60c51ee4c5c9abe4bdbd59bc9e1dd95ecf94353e29c4e55ea119"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c698055560a60c51ee4c5c9abe4bdbd59bc9e1dd95ecf94353e29c4e55ea119"
    sha256 cellar: :any_skip_relocation, ventura:        "a7def9f2b57f1f24347fa58b6bdeeb6af90c0dc955af7a204fa4b8e41bd2cee9"
    sha256 cellar: :any_skip_relocation, monterey:       "a7def9f2b57f1f24347fa58b6bdeeb6af90c0dc955af7a204fa4b8e41bd2cee9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7def9f2b57f1f24347fa58b6bdeeb6af90c0dc955af7a204fa4b8e41bd2cee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "635daaaabab11b48f4b850d914e48d40464d6dcf369f75fd56008cbc20531ea7"
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