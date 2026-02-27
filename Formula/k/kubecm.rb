class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://ghfast.top/https://github.com/sunny0826/kubecm/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "f998972c6df075b7f82514f2d94a39c14fa20c1327f31d637513b4079eb9b67d"
  license "Apache-2.0"
  head "https://github.com/sunny0826/kubecm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b729e907828789c2bb1ad56253d70addcb7f28f53a54fb2544cb134f3f817e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b729e907828789c2bb1ad56253d70addcb7f28f53a54fb2544cb134f3f817e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b729e907828789c2bb1ad56253d70addcb7f28f53a54fb2544cb134f3f817e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d1b5454651dc451ff005c9760e0e008525cd6cb90c9cf6e0ce110b7bc22230a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1b82b37f811d4c662e52541415f46f904c4fe2432e4bccc8d6a53723f7adf00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ac85b589ba9f22383212e1659bdf6ff99da1ee8e82a48ecf9fd88e4515fb11c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sunny0826/kubecm/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubecm", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubecm version")
    # Should error out as switch context need kubeconfig
    assert_match "Error: open", shell_output("#{bin}/kubecm switch 2>&1", 1)
  end
end