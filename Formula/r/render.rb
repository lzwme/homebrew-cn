class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://ghfast.top/https://github.com/render-oss/cli/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "edb56e68cda4dd4ad4b942a82b2bbc00b746a62410330971769ceeb27a8d1e54"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b7af929a3aa5e71459a0f5bc20f018989ab4e9812e517a611b9badf4bc12ff5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b7af929a3aa5e71459a0f5bc20f018989ab4e9812e517a611b9badf4bc12ff5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b7af929a3aa5e71459a0f5bc20f018989ab4e9812e517a611b9badf4bc12ff5"
    sha256 cellar: :any_skip_relocation, sonoma:        "70739c9b7f9a4c2ffa8add97efab903c17733c8282df8b6227131191c693f7a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48951fd3b4bd6f84b49d9357829584e379bf423e2a2eed51aa0991d777375e38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa07ffc9e644dbc8444aa13ce7095dba5655fe7f6bdc12142cc1c9ca1c8999c3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/render-oss/cli/pkg/cfg.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/render --version")

    output = shell_output("#{bin}/render services -o json 2>&1", 1)
    assert_match "Error: no workspace set. Use `render workspace set` to set a workspace", output
  end
end