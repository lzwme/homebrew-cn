class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://git.rgst.io/rgst-io/stencil/archive/v3.0.2.tar.gz"
  sha256 "e9898dd678cd949c8108c4d1bb2ae00fbe1cba64c7b936c9a0fe25e4c9f0680d"
  license "Apache-2.0"
  head "https://git.rgst.io/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d0680e93b782708e6a2bc758075fcd5eb455e355153b97c1510aeb339060af36"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1aeed447ae38105ffe9713aba75c4bb27af7b6809cf3384afd472374862f3822"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5616c8062c45cec5f0fb1097de3f49f7bc61a7ce6edd1e6543a54100ae478966"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5e3ef803e5148106b07296878b1d709b42465e22d4c094029f283e539ea2493e"
    sha256 cellar: :any,                 x86_64_linux:      "0624a63a97fa69fcb251d5f2270c9d7c66b1b8ceb73c365bea5545dc23c5968c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X go.rgst.io/stencil/v3/internal/version.version=#{version}
      -X go.rgst.io/stencil/v3/internal/version.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/stencil"
    generate_completions_from_executable(bin/"stencil", "completion",
                                          shell_parameter_format: "",
                                          shells:                 [:bash, :zsh, :fish, :pwsh])
  end

  test do
    (testpath/"service.yaml").write "name: test"
    system bin/"stencil"
    assert_path_exists testpath/"stencil.lock"
  end
end