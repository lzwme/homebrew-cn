class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://ghfast.top/https://github.com/render-oss/cli/archive/refs/tags/v2.23.0.tar.gz"
  sha256 "7400fc8836c455c14a1cc3eceee61bf1bdd2bb3cc55ea07563f50614eaf9290e"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60a20dee4ccfa3e294dc142e6e9b8c6a79238cde41b3bdee06a30c97fa355126"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60a20dee4ccfa3e294dc142e6e9b8c6a79238cde41b3bdee06a30c97fa355126"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60a20dee4ccfa3e294dc142e6e9b8c6a79238cde41b3bdee06a30c97fa355126"
    sha256 cellar: :any_skip_relocation, sonoma:        "30e7cdf58311e0bbe8e38c2f3b0370d3c1db6117d8af3f88609f004614b34704"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25407d30c28b7e70bc95239633b735a64fd13975fc69bed391f47645f11c4a06"
    sha256 cellar: :any,                 x86_64_linux:  "4201c7fc0bc8871e09dd28c1424ecfee38266ed246f94e99f18e49779066facd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/render-oss/cli/pkg/cfg.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/render --version")

    output = shell_output("#{bin}/render services -o json 2>&1", 1)
    assert_match "Error: no workspace set. Use `render workspace set` to set a workspace", output
  end
end