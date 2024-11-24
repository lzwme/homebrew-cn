class Kubeone < Formula
  desc "Automate cluster operations on all your environments"
  homepage "https:kubeone.io"
  url "https:github.comkubermatickubeonearchiverefstagsv1.9.0.tar.gz"
  sha256 "56009d0982e99d624cfa82e433f63075c1e519273c304b4a73496670c1beed2f"
  license "Apache-2.0"
  head "https:github.comkubermatickubeone.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bf47ae6c90784a9ec05d00889a2a5cd4239605c0b354370e017259358e500f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ae8c30e1d7fc8476110911783fbd553bb0bc18ef276fcd7ac360be3c87859ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3252718f8c30f82539568717059abbb5509295d36856cfe88e0d26048520878"
    sha256 cellar: :any_skip_relocation, sonoma:        "59d426a43d57cd8d1e77a88ca27845e574c0429a111295f7adc7233771b053b6"
    sha256 cellar: :any_skip_relocation, ventura:       "df4aeb4046121b37aad39e31424b07d31ec4981e28a5512eece1f673b55d811c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "424a20cb16843151ecd2c5afec8a5d16cb095d479fc42017dcc09cdd358e7d1b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X k8c.iokubeonepkgcmd.version=#{version}
      -X k8c.iokubeonepkgcmd.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:)

    # upstream fish completion support PR, https:github.comkubermatickubeonepull3471
    generate_completions_from_executable(bin"kubeone", "completion", shells: [:bash, :zsh])
  end

  test do
    test_config = testpath"kubeone.yaml"

    test_config.write <<~YAML
      apiVersion: kubeone.k8c.iov1beta2
      kind: KubeOneCluster

      versions:
        kubernetes: 1.30.1
    YAML

    assert_match "apiEndpoint.port must be greater than 0", shell_output("#{bin}kubeone status 2>&1", 15)

    assert_match version.to_s, shell_output("#{bin}kubeone version")
  end
end