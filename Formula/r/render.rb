class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://ghfast.top/https://github.com/render-oss/cli/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "41c51dc07cb21ed6d5c0fb3e9d58f3775f210f0b28a9798b0c03a6a5aff02b76"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "629b719c1b298e6f25f7b16862746b9131119a15c0164a497ca660ac4fbba345"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "629b719c1b298e6f25f7b16862746b9131119a15c0164a497ca660ac4fbba345"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "629b719c1b298e6f25f7b16862746b9131119a15c0164a497ca660ac4fbba345"
    sha256 cellar: :any_skip_relocation, sonoma:        "8eadeb03db89cbb71915b41df303baba8d6b7668885fc727dacfd37db6d5ee62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "024b997030d420534b4e841d5b9329e85b60c0a33a8d81bc1e924c745b534fc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08e62b6dd9f45fc152f211897cf259389eb626e46e43df215b9643f6a83fe59c"
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