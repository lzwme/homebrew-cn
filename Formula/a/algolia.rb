class Algolia < Formula
  desc "CLI for Algolia"
  homepage "https://www.algolia.com/doc/tools/cli/get-started"
  url "https://ghfast.top/https://github.com/algolia/cli/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "9e861fa2d60d09ca773409f86c45b0ecdfd7c040da01e498e6c8094d0d3aed3f"
  license "MIT"
  head "https://github.com/algolia/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4bc8a4199e3a332cc5be58e861a57cf2823a6da80bc79654efefbe8939f7c09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4bc8a4199e3a332cc5be58e861a57cf2823a6da80bc79654efefbe8939f7c09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4bc8a4199e3a332cc5be58e861a57cf2823a6da80bc79654efefbe8939f7c09"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed7e155ec87c6976015be9501f8605cca72cd6874a1a0bb7bb0f447851c29a90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38fb3f56138282ce478f443cc1d852a92e7ec1a70e98825ba9841112592d6d4a"
    sha256 cellar: :any,                 x86_64_linux:  "be81149493c86df0e9aaac9ec440c6177a230cb4818e970a16bbb04a4e034d5a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/algolia/cli/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/algolia"

    generate_completions_from_executable(bin/"algolia", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/algolia --version")

    output = shell_output("#{bin}/algolia apikeys list 2>&1", 4)
    assert_match "you have not configured your Application ID yet", output
  end
end