class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https:yokecd.github.iodocs"
  # We use a git checkout since the build relies on tags for the version
  url "https:github.comyokecdyoke.git",
      tag:      "v0.12.9",
      revision: "cc4c9795031ff2d9fd9e89ef996ab536de04f8e2"
  license "MIT"
  head "https:github.comyokecdyoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07548144aa6ba1bfc97a63649f78464dd7db4be39a3db8a0e92cb10cd14bdfa6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c962c217b11d928f1f0ccb80cd1b792d4a03924b23ca149496152899dcea45c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4773885907936c4f1c74404c3e3b3e7d24d1fccc3378a2dc2aaea16bbc814130"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f21ba92d8b57e8d34343d21ce7613205007f56d62d967407d44ed1adbdd8591"
    sha256 cellar: :any_skip_relocation, ventura:       "98308059d28c1cfb2d8cf808aa5d240f495ec6beca6b835f919ac809009d41e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2047789a85583308de0dd2bb8c2b77b9628033fc107d5a3a5ec03a66cfa307a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d1420b2473b8e104e800fd2b638eeb6f44c0e981e493cbd97c73ff3dedfeca6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdyoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}yoke inspect 2>&1", 1)
  end
end