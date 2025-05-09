class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https:k9scli.io"
  url "https:github.comderailedk9s.git",
      tag:      "v0.50.5",
      revision: "ccebaa604ef66dd77b9ddc4d2142798a414275ee"
  license "Apache-2.0"
  head "https:github.comderailedk9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cb1b5ec5e30557d6ad635a4e0319c0207ff83a2566d8f0a3e361119b0d28511"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f11599564efb1229c452691e44c16bcfa4b36ab4cbf64cf103e31db73764e025"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d25f04597a4d1c4832132ceaece880af895b82c6b40fc6e6eae7883da6acaef"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f53a00ee90ae2dd273e87fcd80ae044457eff11361016191ff79eb6eab61e99"
    sha256 cellar: :any_skip_relocation, ventura:       "93b0bff3e9eaed0c8a481e7520cf1c2bbe39b9075b5329ab11418be4d0c188bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59abf7ce0f6be6cd410e0bdfbc34d414f463daf33571b3cf1826ff21dd58995a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76e9ecaafb93ad94597913c480fa44226371cf73a7b0e62161331cdce9c845c1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comderailedk9scmd.version=#{version}
      -X github.comderailedk9scmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}k9s --help")
  end
end