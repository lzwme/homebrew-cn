class Algolia < Formula
  desc "CLI for Algolia"
  homepage "https://www.algolia.com/doc/tools/cli/get-started"
  url "https://ghfast.top/https://github.com/algolia/cli/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "59650b3614a1c9d0448877aeef125539b349cf6063828edf0b1e05d69749764c"
  license "MIT"
  head "https://github.com/algolia/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "348f5cb6ed913f696153b1deedb96c6a249a816f25459442cbda78aca2d397fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "348f5cb6ed913f696153b1deedb96c6a249a816f25459442cbda78aca2d397fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "348f5cb6ed913f696153b1deedb96c6a249a816f25459442cbda78aca2d397fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "25f2f605f13bbe24f52220ba47cdd932524d404350980f59b9d9808253be3a7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb3e43043b67d36fb6112f94a1525666a2cdba9f406016bd4569406bd95e0f53"
    sha256 cellar: :any,                 x86_64_linux:  "6e894e2c5e3a91e320b4c76e7fee72e8ed388d556d42de3192405ea3d7c9b20d"
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