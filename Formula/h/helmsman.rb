class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/mkubaczyk/helmsman"
  url "https://ghfast.top/https://github.com/mkubaczyk/helmsman/archive/refs/tags/v4.0.2.tar.gz"
  sha256 "cac2a5bf8740072da474294abac8b9e56a65f15fbcb3849a74c5798a7551a6ba"
  license "MIT"
  head "https://github.com/mkubaczyk/helmsman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abaaa5d4da19fb1ec68ce926fb0e97de45820c29a13597ea879fcd9728716827"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abaaa5d4da19fb1ec68ce926fb0e97de45820c29a13597ea879fcd9728716827"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abaaa5d4da19fb1ec68ce926fb0e97de45820c29a13597ea879fcd9728716827"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b4a053096b3fdb3570a034bb35613d19ce57bf00b86f47de41f2279665fd8b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64dfaca49c9db98bba98949b273190a6664876b3be608ce9a9ee748203971276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7acf0d5dfcbd43a4414bddfbe89197f0392dd8708cde53ed4ce95f8e0bf11ddb"
  end

  depends_on "go" => :build
  depends_on "helm@3"
  depends_on "kubernetes-cli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/helmsman"
    pkgshare.install "examples/example.yaml", "examples/job.yaml"
  end

  test do
    ENV.prepend_path "PATH", Formula["helm@3"].opt_bin

    ENV["ORG_PATH"] = "brewtest"
    ENV["VALUE"] = "brewtest"

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1", 1)
    assert_match "helm diff not found", output

    assert_match version.to_s, shell_output("#{bin}/helmsman version")
  end
end