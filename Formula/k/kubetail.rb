class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://ghfast.top/https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.10.1.tar.gz"
  sha256 "87311cdba53c74c6c03a2d51c87491a2c656beb8187c1ef86cce3430a1faf5eb"
  license "Apache-2.0"
  head "https://github.com/kubetail-org/kubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "620792ab465f0707a318e1cd2129e27ed919a6a5bb2850c7b6f22e4b80fdf009"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a0333a453f77283f5bc88f0ae0086950b8ed0f78659c7812e4ff376293fb871"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40905b20f5df1d0cff517507777e421de4067342b658c894e7326a1bd1c5b922"
    sha256 cellar: :any_skip_relocation, sonoma:        "520af592cb2987e51ece834729345a728a6d39eff301468ea87fd697d4187238"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77f3c6448afe6b34ba85fc650ea8427e4e1d6ff003fb474f5ca4a8a330f7bdfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9c88bf00cfe3c8f05e621f5df273a11ae42fd4bfd69ed17795f4882f2f746f2"
  end

  depends_on "go" => :build
  depends_on "make" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/kubetail"
    generate_completions_from_executable(bin/"kubetail", shell_parameter_format: :cobra)
  end

  test do
    command_output = shell_output("#{bin}/kubetail serve --test")
    assert_match "ok", command_output

    assert_match version.to_s, shell_output("#{bin}/kubetail --version")
  end
end