class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https:k9scli.io"
  url "https:github.comderailedk9s.git",
      tag:      "v0.50.0",
      revision: "e55083ba271eed6fc4014674890f70c5ed6c70e0"
  license "Apache-2.0"
  head "https:github.comderailedk9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f13d6ce6980f0ad040ff8dc08d060b5405bc26e19b041b0ee8dc6670bd63c23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d2671f44a988389f82301e65927a3c0e6c53953898dd628d759fb5d87a55f32"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f48425ef062702458ed387ea3a2f909540a2e1a887294cf780b1471c5f9cd13a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ebf5be53b54bb66c41f210c278a28bf95dce91ecc233823e839ad7aa9b677b2"
    sha256 cellar: :any_skip_relocation, ventura:       "e44236b9774dcc7bf9e2141a00809d16010d3c821982e0d0cdd43020563910e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4221af5f8b2f1dd20addb98cf7c8f97b36c12524ba5d85d4f262b35e09baacf"
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