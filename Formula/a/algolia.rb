class Algolia < Formula
  desc "CLI for Algolia"
  homepage "https://www.algolia.com/doc/tools/cli/get-started"
  url "https://ghfast.top/https://github.com/algolia/cli/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "23f6e2c832546339dffc8bc9178a4190418afa0313fdb8bf8b1eae6f8c845714"
  license "MIT"
  head "https://github.com/algolia/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40d7325126169048781ce1d462ac1948bcf7d384f56594ce477a16e552e83bfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40d7325126169048781ce1d462ac1948bcf7d384f56594ce477a16e552e83bfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40d7325126169048781ce1d462ac1948bcf7d384f56594ce477a16e552e83bfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "3717f576db4d82f9bc6e27244e42c375e3a32f031dc673677441a2ba08803fbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a26856e56733af8562ef17757d0248734e86d29a7898a08acb64c1012844142"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fc66ce3c26589dd6bfb74dc3670e3c6f86e6aa37741fcd517ba85cd283aed42"
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