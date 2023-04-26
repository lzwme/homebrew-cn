class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.13.2",
      revision: "381b37568805399fca4cc041bd4915a98338c1cb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66dc47eb686d1942fc7e7b7be71c959efabfe56d1e827e7a9f6d4dffd412792c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f1c867f7ed88e5d19df3434a7bcbd5fc1112a71d6b51e4ed118f365f809a590"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "487278c973eccd46cdff5b093aafb9b72cdfd074422f7b0dcadfffd6fb834551"
    sha256 cellar: :any_skip_relocation, ventura:        "5998391823305881d8467d1a6a27576ef7b2d553a716b7634d074d0f452bd41c"
    sha256 cellar: :any_skip_relocation, monterey:       "1f004ae8e4b4ecfcfb0d3e7aaa06842a5418b8bbc8204b0ea624a54fb7689e64"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab1e817a1854d2d6e9003b9a5504fbc2fe852984564c36c59258068f3ab488b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac28829032f6479a80179f3c0617560dd3eb83680ce9b29e3253de8204cbb54d"
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