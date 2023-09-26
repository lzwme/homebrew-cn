class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://ghproxy.com/https://github.com/lima-vm/lima/archive/v0.17.2.tar.gz"
  sha256 "fcc3ea1de6fe5910fb1a436729e2aecf6c9b261e5c2e55a1c6754d9a5b75eb49"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d33a62f9b31f25e90047ec529a106ed3b1bf63169830dca3c7fb9e9812eec74c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b769e329437f18161ac7074812ffcf58c0c5058db0896385888f31fb221b093e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56a03be6d965a803fb90821c5f52708586c87ba0930802689144f4a805fe145b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a585e425992231d6a0f92496a7a453369e7ad6b6a3e08ff0bb52629e90b9450"
    sha256 cellar: :any_skip_relocation, sonoma:         "b0c9d57c9c6cb008f3f7b07bb2e7b8c5fc0cddff6be1a1a305651ca91126c3a8"
    sha256 cellar: :any_skip_relocation, ventura:        "8f3e4f1a72b2cb2004e7ba85ebea702538f0779713c23b3a9bd1e67f10ea0e65"
    sha256 cellar: :any_skip_relocation, monterey:       "6a03f375958a5a32baeb05661fedfa632b13169efe28ea70d727b9bb10661870"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9f34bbce59c9b0c2bd7a21ef867a5e6882d4d3eb15df69e64afa2e9e10ec72b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9924f7e208f4298e5f98ca0444b2ae3a0f65459a1ccf389040b724e2e45654bd"
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