class TerraformProviderLibvirt < Formula
  desc "Terraform provisioning with Linux KVM using libvirt"
  homepage "https://github.com/dmacvicar/terraform-provider-libvirt"
  url "https://ghproxy.com/https://github.com/dmacvicar/terraform-provider-libvirt/archive/v0.7.4.tar.gz"
  sha256 "050437a9681bebe686ebad7ae1a6b0004238302a5775169f47403cc79392741f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "029ee9d307e02e19cc2c64d26cfe6ffaeb2a26924065183bca3d0554a712a115"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa30b87bb66737daabb6607771f3b578a05c7f17f5cafdc9ed35a15ee0a0c2fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81b2606ae1979e46518b726157f244deee666beedeafddd3b58a3c55823f2781"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ab7cc3e7795698a41b82bc395a5136d0fd8aba69529543cd491a3c5bcc0793b"
    sha256 cellar: :any_skip_relocation, ventura:        "8190611d51cb86dbbecf4bfa79bd99455e5a488ba3869bed075f49befca684c4"
    sha256 cellar: :any_skip_relocation, monterey:       "fcc6d4322f741baa3cc61a426a62d07b32c8a503972d35a9a72b67c0e86ed7ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b6b4666aa72e57de57e4c803cb28f4671064b41cc5cc0abd6ace708b6970586"
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