class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://ghproxy.com/https://github.com/lima-vm/lima/archive/v0.17.1.tar.gz"
  sha256 "6fe0abf31fad9c2b09d1de11122cfd4cf2db9f39f83f371c6ee21107807a7da6"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e0268ce1ea77076ddb18cb96c1ce5e0c46c70b4f7f1f2c725e651926103aefd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9fc381d75f8fe7f012265ab72053edad367c55edcb2fe32a4bdc4ec4474a57b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d964f63a2b9f31b34b902ab3c873ca6e99ce7ad93361198343dc361536aa6dc"
    sha256 cellar: :any_skip_relocation, ventura:        "4b0475e207bb589897d9675e596795086a141f64b7d65d899f0bc8e537c30d20"
    sha256 cellar: :any_skip_relocation, monterey:       "2a38045e6c7ffdec72efe5504075ed5d83bb49451bc9c58284eabfcfcfefe769"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f111af0ca3f202b55d16d4809c8dd9397dc9b5f50642bb6d269bd88456bc52d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f80ab2d2ae3e1d1a930bfa217ff7dffd2269ffed9202aff98844faf02e1e0e28"
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