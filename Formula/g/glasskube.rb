class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https:glasskube.dev"
  url "https:github.comglasskubeglasskubearchiverefstagsv0.2.1.tar.gz"
  sha256 "16b19b957fef730a75908e5abedd9530776f6a2b356d47611e4b51c8b98fc490"
  license "Apache-2.0"
  head "https:github.comglasskubeglasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f8f8012dc928da37dfd65c19d7904d3dfc90908bbb6fa66fae818b6244d560e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "304d09d3e867bac5d7a4b4218899bee87ab3cf774adf7478050e9befdc3f9342"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22eafc378e7bf1424789e0921ab2f885f8f077f6a75b5b11cb5eda416109eab1"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd38f377983640a6872f3b60fa1ca762f9148223cd7bb0029ff820284a206f52"
    sha256 cellar: :any_skip_relocation, ventura:        "c287c18056aebdece05a35c0a9e773a912de3abee0b2a1d947f59d3e4af4bd76"
    sha256 cellar: :any_skip_relocation, monterey:       "a4d2618aedf2ee53dad519496af624013a0482b4441fbaf6fe8f32061588b783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e73f0a4c801b5f113a36c9e64a086878e53ec6fdc16f80ddbf60cd6df422554b"
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