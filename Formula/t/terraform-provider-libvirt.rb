class TerraformProviderLibvirt < Formula
  desc "Terraform provisioning with Linux KVM using libvirt"
  homepage "https://github.com/dmacvicar/terraform-provider-libvirt"
  url "https://ghfast.top/https://github.com/dmacvicar/terraform-provider-libvirt/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "199640aff2cec224a69bef00190bd6364c8cc636aaf5db6d3017edcfc4b0d3b5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68d2793ad483ff80f77b39012b77aec09e9ebbcc0419d225cf38d4de7a80838c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68d2793ad483ff80f77b39012b77aec09e9ebbcc0419d225cf38d4de7a80838c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68d2793ad483ff80f77b39012b77aec09e9ebbcc0419d225cf38d4de7a80838c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a0b6ad0a89ad3e490d8d9125287de44c4c1aa16dc3bce4f467bff1f0d514d8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11b0d3becdd4256fd8b6bef37c14354d7b6d410afc9645cfa38d81defd397039"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "248c3e552abd6b4cd2990a0d5294c6112f6e6f1fafa9acc1c2658db94f69807b"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  depends_on "libvirt"

  def install
    system "go", "run", "./internal/codegen"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match(/This binary is a plugin/, shell_output("#{bin}/terraform-provider-libvirt 2>&1", 1))
  end
end