class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.45.tar.gz"
  sha256 "0b90e31b2a3359421dc55873bfb39b5cc2dd3fe28387d34f2a12508bf026c829"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d5a885ac0ee8d64ef59725942aed5ed4217c0d9749e833d18b85ee08e4ad453"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bca63c6b0a071cd26ca33e41a4e5a061962e0b3e5381d929de921c4a855c4b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b44a3e3f75362fd65032508014c5a76754f80a5529921339319ebc8226154621"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7640d583d79e49ca5bc314b95fb9ca3ffa71aeb18cc4e40b41a8d2492d186f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d16cbad2cb6cc4377821e93d8018011c98160a1aa0c2428edb019229122f31ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cf730ea3ab590c355525aa0c52d68f8a68d32dfeca0525c9ce97a07b87f0cc7"
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