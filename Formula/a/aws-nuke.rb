class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://ghfast.top/https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.62.2.tar.gz"
  sha256 "589c4a8a041d8e6325859e6de8bb72ed8d4f8fc940748493580c6373e2a97efb"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9648532c7c3e004ee3e46d76b359c40ac95bd7485d3b51e3d2c6b6bfd0dff53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9648532c7c3e004ee3e46d76b359c40ac95bd7485d3b51e3d2c6b6bfd0dff53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9648532c7c3e004ee3e46d76b359c40ac95bd7485d3b51e3d2c6b6bfd0dff53"
    sha256 cellar: :any_skip_relocation, sonoma:        "a135f10116297bcb89ef24de7e4e3cd7bcb9d98f49db1db697cbbbff4a82fda3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ebc3694d60832aa5b844f54563c9217433eb46c256af9a42852c4543055227b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc41eacf9e2d0acc76ab5f4e5a5089207cf9794c9288c77ed3976c68a559d74c"
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

    generate_completions_from_executable(bin/"aws-nuke", "completion")
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