class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.14.4",
      revision: "41747e8ab5e1ff2e8b189c3624400a95b93b8b3c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29de5d68c1822d3f61ed7bf6c65f066841c22d7982b16258a9308ef07bad4aff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "887e4b0843a87da01b6151c5ca219f476ac6f4953fa60b897905e626b551b8af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f43dd9c1236242371381e1fbdd86dea6ab1bc1e477ef90dbd8b6156963dcd6e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "a75f9e5c2bf824eb407e6d1d2b7069f510658964c2a5f2463315901444c2265d"
    sha256 cellar: :any_skip_relocation, ventura:        "4ded85302b5a89cc36b28e5c07d9562d270d49663fb9e96f5e34f0aaa3469f83"
    sha256 cellar: :any_skip_relocation, monterey:       "ad8567b0f031976b03e43daa816cb6847ae2cd752a3db6978b7e89829ef70498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b7922b1d9d75368f02135a4e168722aef27f8f3c8de2ca8967531a97c02dbfa"
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