class Algolia < Formula
  desc "Command-line tool to manage Algolia applications, accounts, and search resources"
  homepage "https://www.algolia.com/doc/tools/cli/get-started"
  url "https://ghfast.top/https://github.com/algolia/cli/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "47439c44ca0fbf1ba3d0943d756a747b595f219aba2728ec40c4493143abe202"
  license "MIT"
  head "https://github.com/algolia/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5fd8c70cfeffd73a75eb1547ac288fbe5125038426968237be13a03edb5deba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5fd8c70cfeffd73a75eb1547ac288fbe5125038426968237be13a03edb5deba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5fd8c70cfeffd73a75eb1547ac288fbe5125038426968237be13a03edb5deba"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3b557646ec9f8d201a7b198f5f9d7fe0948002b1a5da2f93433d75e259bd820"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "233ae1aae6fd6060e41aaf3c61b36b454cf42c7fce40bdad25042af7b79fc235"
    sha256 cellar: :any,                 x86_64_linux:  "1db52f2f95d8084c0f896ecda5ecdf593faa29cd94cd814382f806275e533d92"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/algolia/cli/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/algolia"

    generate_completions_from_executable(bin/"algolia", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/algolia --version")

    output = shell_output("#{bin}/algolia apikeys list 2>&1", 4)
    assert_match "you have not configured your Application ID yet", output
  end
end