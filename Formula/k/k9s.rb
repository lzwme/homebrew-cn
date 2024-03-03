class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https:k9scli.io"
  url "https:github.comderailedk9s.git",
      tag:      "v0.32.0",
      revision: "0d1653101696aaed67984d0188407503426c20e0"
  license "Apache-2.0"
  head "https:github.comderailedk9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bcbc96a8ad421a68503163ad9c41f36f09b47ac5c73fd0892eb3c371e1166ac1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44e3ca55c42a2385a709ed815e9dcee84d7fa4e5baf2dbc86d805ea566f0d807"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0995b7f65872ce8123a611da40fe85a608e7d15b7a9dbfad0aa8ef40ccef0770"
    sha256 cellar: :any_skip_relocation, sonoma:         "6787eba7c93d0527ddbb559bae054e0767c447d201b0dc81418132a5fe87eb42"
    sha256 cellar: :any_skip_relocation, ventura:        "c59ef36df450c54c5e6a4675e0ac55b057c67011153cd55ff7121141d6a9ccba"
    sha256 cellar: :any_skip_relocation, monterey:       "b08854173f6b8a270f4bc49a16b29003e62c37b89b583da488ff4a4c59b9ea02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22ce8c2b4018b698e27242478a043ead8ddfb7a63a4c1591e868faae08d11bda"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comderailedk9scmd.version=#{version}
      -X github.comderailedk9scmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}k9s --help")
  end
end