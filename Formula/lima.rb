class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://ghproxy.com/https://github.com/lima-vm/lima/archive/v0.17.0.tar.gz"
  sha256 "b4980ecc43585473676ae216698e997a4eb16e8a94a99434644a6e87a6370b88"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b98e41586e63556bb45339004612f5618ed2cacdb243abde5d8706aaca2be7b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56ccf8bd12a05218989c20d2bbc8bf92a8ede6d823a8d80c6fc46afa9a96b334"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61ca5103232ab542e5ab5c5d0853e438e24305b7db196bc7eee0560b0c9392bf"
    sha256 cellar: :any_skip_relocation, ventura:        "0c7c25f2bf140faab8980f1c0053c3bd6d83229b8f4a3f162ff53106c8e0b8d6"
    sha256 cellar: :any_skip_relocation, monterey:       "49d2992b1af83bd052d79a0ce14621c4feda8da3b1a2466baf98bca81431bdfc"
    sha256 cellar: :any_skip_relocation, big_sur:        "92f961406f1074cc0e9aeaba642a75088b6c68c8c1ff04e91496335b1020f235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac00410a4379b10191663cad621517c532c733bb0f51e8781920297514ecb779"
  end

  depends_on "go" => :build
  depends_on "qemu"

  def install
    system "make", "VERSION=#{version}", "clean", "all"

    bin.install Dir["_output/bin/*"]
    share.install Dir["_output/share/*"]

    # Install shell completions
    generate_completions_from_executable(bin/"limactl", "completion", base_name: "limactl")
  end

  test do
    info = JSON.parse shell_output("#{bin}/limactl info")
    # Verify that the VM drivers are compiled in
    assert_includes info["vmTypes"], "qemu"
    assert_includes info["vmTypes"], "vz" if MacOS.version >= :ventura
    # Verify that the template files are installed
    template_names = info["templates"].map { |x| x["name"] }
    assert_includes template_names, "default"
  end
end