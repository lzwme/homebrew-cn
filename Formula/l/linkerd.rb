class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.14.5",
      revision: "317b19b3d7d1505a5700e361edf56788ffe99c56"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88f9eccbda1ea8e481ac31428db46885ce1e32714cb02a622495d680e1c42142"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71114a14be7ba659f775ded802bc0e9b38c747012e0cc3f5eaeec0f6ea6a9908"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e2d9fad6638e28447d66b4ce78951ea306a8be323d06f604d4d2ad713245436"
    sha256 cellar: :any_skip_relocation, sonoma:         "ebf6f79f5d9705f09fe00a53f3b63423e2c46382ecd7822262640210a6cbddce"
    sha256 cellar: :any_skip_relocation, ventura:        "6a5bf3f40b7adef27afa5d78cbabf48ebedb32648cd89a86bb817d3ab6b82bc0"
    sha256 cellar: :any_skip_relocation, monterey:       "0534cd701b7e8e9377017ad175ba664aba1f32095326e9c8758664521aef6ee0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba95056033b98bc49a65afc04364c2aea6335f0e92a68b575c75d91325f1e5a0"
  end

  depends_on "go" => :build

  def install
    ENV["CI_FORCE_CLEAN"] = "1"

    system "bin/build-cli-bin"
    bin.install Dir["target/cli/*/linkerd"]
    prefix.install_metafiles

    generate_completions_from_executable(bin/"linkerd", "completion")
  end

  test do
    run_output = shell_output("#{bin}/linkerd 2>&1")
    assert_match "linkerd manages the Linkerd service mesh.", run_output

    version_output = shell_output("#{bin}/linkerd version --client 2>&1")
    assert_match "Client version: ", version_output
    assert_match stable.specs[:tag], version_output if build.stable?

    system bin/"linkerd", "install", "--ignore-cluster"
  end
end