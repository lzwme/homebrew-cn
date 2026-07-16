class Algolia < Formula
  desc "Command-line tool to manage Algolia applications, accounts, and search resources"
  homepage "https://www.algolia.com/doc/tools/cli/get-started"
  url "https://ghfast.top/https://github.com/algolia/cli/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "3ddf9e31ac85ac8bee5be6409dbd2fa98e4296934ff903f3b610487fdd1887fd"
  license "MIT"
  head "https://github.com/algolia/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94e91f5e756d528b3713dccc583ac56eb39c26349e6c07f78aebb90058034005"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94e91f5e756d528b3713dccc583ac56eb39c26349e6c07f78aebb90058034005"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94e91f5e756d528b3713dccc583ac56eb39c26349e6c07f78aebb90058034005"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e09045910909a2f04cab1001806c23fab845cfec9ad99e34eda6842b8e36308"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "218de10e838d7f93c004c23dc4a4a01f4551e4709244d8d162f27ce4e9897029"
    sha256 cellar: :any,                 x86_64_linux:  "66814d9e98f92a9baf00ea47a8ddec5215175da94fbd2644da08f26dcf9e91d4"
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