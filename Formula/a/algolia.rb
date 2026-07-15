class Algolia < Formula
  desc "Command-line tool to manage Algolia applications, accounts, and search resources"
  homepage "https://www.algolia.com/doc/tools/cli/get-started"
  url "https://ghfast.top/https://github.com/algolia/cli/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "e536dba169177d314cd565affd7be6c48a52df523c9b705c57b7aa91d479ddb5"
  license "MIT"
  head "https://github.com/algolia/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6396833a89627486c201315b14cbe673c954a4b56e71b3d88d42318fc3c83761"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6396833a89627486c201315b14cbe673c954a4b56e71b3d88d42318fc3c83761"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6396833a89627486c201315b14cbe673c954a4b56e71b3d88d42318fc3c83761"
    sha256 cellar: :any_skip_relocation, sonoma:        "11326c79dc95c55dd724454b6d87ace871b0388baf50dc4b7b41e63dd409d62e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dffac1c506371e34eba8184551dc16dab5e7d01c69f97ae319208f91fdde441"
    sha256 cellar: :any,                 x86_64_linux:  "52b924b08c9da96ca28cd51c1bcf12a9819944dac7834038f207c919e68c805b"
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