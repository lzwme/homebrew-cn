class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://ghfast.top/https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "71e38ab92715fd7ed672d23e9f04d7441dfb54557f1b344dc50f434b1e7e7516"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41ae1970ec1b53599e8220339300abc1930ed05edfad0dff98181a780e2d20f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41ae1970ec1b53599e8220339300abc1930ed05edfad0dff98181a780e2d20f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41ae1970ec1b53599e8220339300abc1930ed05edfad0dff98181a780e2d20f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2792a188c24813aedc86e3bf146ec7d9c1876cb61cd0ccc72fa469b513276c5c"
    sha256 cellar: :any,                 x86_64_linux:  "c3c5e9a475ec3651935021b4da3f751c9c6bb80b77b7c7a2a0222243dd4ceb3c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=brew
      -X main.date=#{time.iso8601[0, 10]}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/crit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crit --version")

    (testpath/"hello.md").write("# Hello\n")
    system bin/"crit", "comment", "-o", testpath, "hello.md:1", "looks good"

    assert_path_exists testpath/"reviews"
  end
end