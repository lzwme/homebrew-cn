class TerraformProviderLibvirt < Formula
  desc "Terraform provisioning with Linux KVM using libvirt"
  homepage "https:github.comdmacvicarterraform-provider-libvirt"
  url "https:github.comdmacvicarterraform-provider-libvirtarchiverefstagsv0.8.2.tar.gz"
  sha256 "b1770b8980a093af43f5f449c3365c6b99ef184b1d6e531d03979959fff279e9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baee4afe7c364f653c4451b68cc90f153563f9f24243a54c099f3a29863d374d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baee4afe7c364f653c4451b68cc90f153563f9f24243a54c099f3a29863d374d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "baee4afe7c364f653c4451b68cc90f153563f9f24243a54c099f3a29863d374d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1c7e6b94dec56184f0f4af4a2a6b33bb96ead06c54f5ebfa622169f4778b344"
    sha256 cellar: :any_skip_relocation, ventura:       "b1c7e6b94dec56184f0f4af4a2a6b33bb96ead06c54f5ebfa622169f4778b344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3946ea25febdeaeb1dd5b05ab0a734da4eecf88083d909305ccdacdb33eab846"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  depends_on "libvirt"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match(This binary is a plugin, shell_output("#{bin}terraform-provider-libvirt 2>&1", 1))
  end
end