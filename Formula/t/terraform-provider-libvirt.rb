class TerraformProviderLibvirt < Formula
  desc "Terraform provisioning with Linux KVM using libvirt"
  homepage "https://github.com/dmacvicar/terraform-provider-libvirt"
  url "https://ghproxy.com/https://github.com/dmacvicar/terraform-provider-libvirt/archive/v0.7.2.tar.gz"
  sha256 "061825d571ecf71a9badb9ebd347d764b5ffd62bfa5b785a2bd75dfd3b92d550"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "300293eb038029f1dc3fed8c13ab857056543fccd538a880ecbf836c2158bf60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f4754faf48bc830f3fe1314279939dd99b1681c3475956b57a385f03e701aad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ec9cea8b2489cc40969a7f5cdcd32eb0166af5360981154528420a42a4bd5ad"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac5b5283228689033abcd84d1e8068ba29a62edf037c2346543e9a508b72c5b3"
    sha256 cellar: :any_skip_relocation, ventura:        "b8641db132006af0e44aa4ce47a76daa0504185295bc035f3c691fa699f603f7"
    sha256 cellar: :any_skip_relocation, monterey:       "54f4c57fa6384476517d08f82e05035de5b4f385273ae91db040d7385a7230f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15c23352d4c5a5f282ee6021189e631435e3932c8391ae400fb4747e07ce44ca"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build

  depends_on "libvirt"
  depends_on "terraform"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match(/This binary is a plugin/, shell_output("#{bin}/terraform-provider-libvirt 2>&1", 1))
  end
end