class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://ghproxy.com/https://github.com/cilium/cilium-cli/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "af230066ec558760252fe5ab23ff1436481a0ee6c5f28f1251190ce4f9479a99"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "495af979a1f8f3a1e68f01b8ce9db280fcf33b76ef48f50ae494ee8e81dd38a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b153cd033291b0ddaf2c4fc5d2466050b193f61cf56db0f759f1882fdc44e146"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2c765660594082ebeed809a96df529c5be07cf8afd9416202fd8978ad7e3a6d"
    sha256 cellar: :any_skip_relocation, ventura:        "3f82318d3a18921465b8924252502c8f871a7cb13b5e8aa40b002c14a81e63d9"
    sha256 cellar: :any_skip_relocation, monterey:       "095b03ddfb1fafe44df5da3afcbbd1195b891b0f8a465ed778bd000d5a9c4f89"
    sha256 cellar: :any_skip_relocation, big_sur:        "26ecc3a415e045c7eb5b3cd58ecc00b3d3ed32c114b220e46b8abb870f81085d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9ac72c715ffcef1fb638d260feb34929bd77b52c2f4ca2c89d9b8739e863652"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/cli.Version=v#{version}"
    system "go", "build", *std_go_args(output: bin/"cilium", ldflags: ldflags), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}/cilium version 2>&1"))
    assert_match("Kubernetes cluster unreachable", shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end