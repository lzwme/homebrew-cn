class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.47.tar.gz"
  sha256 "ae96f87558960d58e84011964d26362f3e3d145d138b4524b3aba60a9ca35b15"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e798f0fd3899d5d496ee9a4a78824ab71c376ffc7937ba0db2d9e0765965201a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0723a994a6e3cec591af80ce5a03fa1b0413bc3413f9993d4249c9096dc65662"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76d1a105f2a5f6faec919a36267f3014978c058097541e7ea6f31e73a68ac6e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "993953c2b68e9667b5e3449d390a921021975e32576abf31cec0f477ac5d21b0"
    sha256 cellar: :any_skip_relocation, ventura:        "c64a06b75d062ada21d1586a258b033a80a4e42aed24184ef9009aa2ca093d35"
    sha256 cellar: :any_skip_relocation, monterey:       "a14650dd59f4c6ae3abc65a0380eb83628d9fb97c78333ab3edab7b0254f7e53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afc4007451fb3e064126196587da70da8370ce7fbd3ac268622deb548cb6f986"
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