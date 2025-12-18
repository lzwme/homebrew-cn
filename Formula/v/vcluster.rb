class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.30.4",
      revision: "8770824aad31e41e69253f68f01f1ba01ea91d31"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bde3884f9038ca818f42ee4d45a6f501e0c112c186ca77b07a7a382d591d9b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35c07bd8d3e86df0df81e43e6586f45ff296de33d0a1d2f0c6c5cf2ed8e2f7a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71df9f2f7558a3d19f70cb08d4615a9b907356e9aa416b4554921bb008d8d6b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f9ac82ac1950441c6fb6bf03a18c8c61df91a54ce53bc0906c9be3fb49c9de9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a70e41273eccb833f5a93e54c13f56952cd7251549ea13eec6b7c397ab160fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1afb90b0f4f46dd9fe3cb7285290dde536ba1e9f23b715023d2a513766d47271"
  end

  depends_on "go" => :build
  depends_on "helm@3"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.commitHash=#{Utils.git_head} -X main.buildDate=#{time.iso8601} -X main.version=#{version}"
    system "go", "generate", "./..."
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags:), "./cmd/vclusterctl"

    generate_completions_from_executable(bin/"vcluster", "completion")
  end

  test do
    ENV.prepend_path "PATH", Formula["helm@3"].opt_bin

    assert_match version.to_s, shell_output("#{bin}/vcluster version")

    output = shell_output("#{bin}/vcluster create vcluster -n vcluster --create-namespace 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end