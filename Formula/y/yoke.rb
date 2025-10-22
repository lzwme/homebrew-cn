class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.17.1",
      revision: "f9fb08e436bed2f571577dbeb0c6bf9dc75973db"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5000d79bc88054031be84ed5f797db2f4be8b37ee26b5c11b3871aa10a7e959"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c20f496b63b76bf9414e3034c23d27568a0fb04da69a330786730df47337bfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55f57afe1f50751cb8d8bf2b1f9de771cdbd6c9c34e64bf34c02fe02f623abf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed99ea828df1382797dbdeb7ffde51a310e2101671b2d914358b102ff360f49b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17baba7f374fd5d7a0075d95adfebb04d3b36a09f5eb56c92c134d6045f96df0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a535fede1db8c15391d5015ade9978c852eec53d5eccea899c4758dfa52c696"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end