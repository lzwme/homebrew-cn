class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https:glasskube.dev"
  url "https:github.comglasskubeglasskubearchiverefstagsv0.4.1.tar.gz"
  sha256 "fe679c3337eacb38d4f4419715f99103857b8665867ec5d13c213b04b3d9adf8"
  license "Apache-2.0"
  head "https:github.comglasskubeglasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a1bb13f7de3dbc4fda04ac9093cd29c7bc181143c1f0b3f34602040d1637f515"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6155900449b5c90e1c2dcb80d670929983398917470de7106ab2d55d8a94bac4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a2558b71a0cd5df5de3d2439b84a166e3d7b506b5bb4d8f5934b3faca0bfc72"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb08f762afaba88fac3c988a02ec7bc555070e6ee0483fef600299a9b1917907"
    sha256 cellar: :any_skip_relocation, ventura:        "b26bcdd86b26f36fbbdbab5db42b52acab617526d7306058a38e853ab8cbeeb0"
    sha256 cellar: :any_skip_relocation, monterey:       "452f777350f7ae3181499ee36a4afe202accdcbcab2af18dbb44c1e4bc48b84c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c7e5d1d6b7e08703c809f87cf913a1fc52759a271466ae50a7e6da1cc7befef"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comglasskubeglasskubeinternalconfig.Version=#{version}
      -X github.comglasskubeglasskubeinternalconfig.Commit=#{tap.user}
      -X github.comglasskubeglasskubeinternalconfig.Date=#{time.iso8601}
    ]

    system "make", "web"
    system "go", "build", *std_go_args(ldflags:), ".cmdglasskube"

    generate_completions_from_executable(bin"glasskube", "completion")
  end

  test do
    output = shell_output("#{bin}glasskube bootstrap --type slim 2>&1", 1)
    assert_match "Your kubeconfig file is either empty or missing!", output

    assert_match version.to_s, shell_output("#{bin}glasskube --version")
  end
end