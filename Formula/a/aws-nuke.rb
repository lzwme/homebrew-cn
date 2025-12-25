class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://ghfast.top/https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.62.2.tar.gz"
  sha256 "589c4a8a041d8e6325859e6de8bb72ed8d4f8fc940748493580c6373e2a97efb"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0752bc50fc3310b41e75c663ee7fff4b25762a94ed091c1c04659b71ca904f3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0752bc50fc3310b41e75c663ee7fff4b25762a94ed091c1c04659b71ca904f3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0752bc50fc3310b41e75c663ee7fff4b25762a94ed091c1c04659b71ca904f3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5c5939d7eb38628dbb9706ddcc862abb837f338ac4ca9cd08f2701691d27cab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d6b55bf4d99f9e82739c5559f04ef18dd38f39b049f110f6c04eeeb9d4d1dd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "654d8ea21b48c8b59b1c7646f01c33202cc292b6f1a4691cdb0ddc2e98247b7a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ekristen/aws-nuke/v#{version.major}/pkg/common.SUMMARY=#{version}
    ]
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "pkg/config"

    generate_completions_from_executable(bin/"aws-nuke", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aws-nuke --version")
    assert_match "InvalidClientTokenId", shell_output(
      "#{bin}/aws-nuke run --config #{pkgshare}/config/testdata/example.yaml \
      --access-key-id fake --secret-access-key fake 2>&1",
      1,
    )
    assert_match "IAMUser", shell_output("#{bin}/aws-nuke resource-types")
  end
end