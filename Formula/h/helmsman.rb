class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/mkubaczyk/helmsman"
  url "https://ghfast.top/https://github.com/mkubaczyk/helmsman/archive/refs/tags/v4.0.4.tar.gz"
  sha256 "6dd47674471c18852e1d0a7c1ea81a9c8a88136f51dd9a9e57a96fb688581659"
  license "MIT"
  head "https://github.com/mkubaczyk/helmsman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0986f7255d73086e919183a568edf55acc8262bb5a94ec7e7d0efa5052c34f2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0986f7255d73086e919183a568edf55acc8262bb5a94ec7e7d0efa5052c34f2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0986f7255d73086e919183a568edf55acc8262bb5a94ec7e7d0efa5052c34f2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e39df64f641a76be673ca5b1bfcfb8ea7f2ed705d0ec2557924ec3532d1d77ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a94fae4fec4750c965ed5be21263782949cc1d9355f69d46dbde8019719beba8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d696735585ea0c667b3895086e0a341ea31912e8db59a44532f8811ba6755c4"
  end

  depends_on "go" => :build
  depends_on "helm@3"
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X github.com/mkubaczyk/helmsman/internal/app.appVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/helmsman"
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