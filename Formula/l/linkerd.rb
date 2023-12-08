class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.14.6",
      revision: "11b5ab8f4ffe7baa7f596391b5de0312854d8fae"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c433bb2e08bf242c6aa8f165e2da913456bcd8b589aaa092a625b9781330a7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cddad043be1e48df8f6c9686eb232b717ddb93bd772f727c0badb7ee3ee9b67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a68535264e076294ef28149b26fc36ae624910f3d10ba837ccd8d0c3e7be31b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "d26d6208725d3bde796c9093a83161b7ad35d7509e202a2027f2281636092d04"
    sha256 cellar: :any_skip_relocation, ventura:        "eca4c1dada660e0257017095a46f0d9741d3c986afbeb1d608a1ac2b9969851c"
    sha256 cellar: :any_skip_relocation, monterey:       "fbe3c7c625c9731bded0f7d31bd07b09efc4ddb7cb2d6be6895b3a91382f1047"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1b934f48acefc51e23f04218672e2748cf708d8796ed5e73c4f0d9b461d41b5"
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