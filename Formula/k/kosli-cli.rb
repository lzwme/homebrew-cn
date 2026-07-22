class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.33.2.tar.gz"
  sha256 "34f195acbf3c58885529de78ea4f3b49f58ce9a488f452d9f48dc919c455f34b"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1beb7ed6e02e420182dac0e5d69926a6a6bf1896c824fee049686fd09c2c5059"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d600016170e5fe62aac475879d76a7fe609dcd5d991961985d78342ea7e25a06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "247499e993bbd288d7465be6b4ae8472a029497d439d271b56e5731acc4fa639"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c960f246239ea28f51b749aac9604352e73691ca48a6e83d83e1f7129fca1ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d854f7ae9fc6d94609840f249fb4b8d8f81ae4d673ec9f8172cf23a0a6a64efb"
    sha256 cellar: :any,                 x86_64_linux:  "0f48de352057fe624123a114da0533f455ea92b322c2cddab82c2d73ddf28a29"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end