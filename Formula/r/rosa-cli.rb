class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://ghfast.top/https://github.com/openshift/rosa/archive/refs/tags/v1.2.58.tar.gz"
  sha256 "713bcf6599eb98bcd8662683434c60ebc0b7278d4a1a020620248925594913e5"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "215cf15631f6c2171b77029b728afc8b54b3e9673756061fe6738ea89890acc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ea60dc73dcfe6135d6bf5c225032f74c21eb6de41bef524cb539171ebcd0e68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01b10b4331f7bae9f051bee0ce59c6a0f6f33404e7929220141ae1069e49b8bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "16bc8d7e1716d3494c0afccbb1f456d123bf905b19e64d2d3a5f0369b7fd5bbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "871407809db89f8f4685a6244d6118c39f29a9d0bece635a9a672d70a8c134db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b46ba39da40169a4fded2871ce7e1dff234934d855ffaf440e227f272b00db25"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"rosa"), "./cmd/rosa"

    generate_completions_from_executable(bin/"rosa", "completion")
  end

  test do
    output = shell_output("#{bin}/rosa create cluster 2<&1", 1)
    assert_match "Failed to create OCM connection: Not logged in", output

    assert_match version.to_s, shell_output("#{bin}/rosa version")
  end
end