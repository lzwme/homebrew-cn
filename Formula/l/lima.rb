class Lima < Formula
  desc "Linux virtual machines"
  homepage "https:lima-vm.io"
  url "https:github.comlima-vmlimaarchiverefstagsv1.0.0.tar.gz"
  sha256 "49dd844715f99e86a80e13e1f37ab55e11a775aa68c099bce4f4cbf5666260c4"
  license "Apache-2.0"
  head "https:github.comlima-vmlima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f77a81bfe0ae3f92c8b43c819ea09051f8176f32fcb16f53828ceb925443a788"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d365371f6f33cd27d66ea4a310967cfd129e23be822f70349a02b6d55979697"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa4313273644e5abadb1ce3e98925be9a0338578ed3debc29a1846e2a8caf990"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e6a2db42dddd644e8eb869ad7e0ed7ff021cd97008f92c4742fc4c92d7cd7c6"
    sha256 cellar: :any_skip_relocation, ventura:       "722b95f10917891d036d9194d40fea2454029071327ca314397faa72f09541d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11d3a4c3c385ed52581acc3d90db5ce047667b49eb90d921a4adf1bbdbff329a"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "qemu"
  end

  def install
    if build.head?
      system "make"
    else
      # VERSION has to be explicitly specified when building from tar.gz, as it does not contain git tags
      system "make", "VERSION=#{version}"
    end

    bin.install Dir["_outputbin*"]
    share.install Dir["_outputshare*"]

    # Install shell completions
    generate_completions_from_executable(bin"limactl", "completion", base_name: "limactl")
  end

  test do
    info = JSON.parse shell_output("#{bin}limactl info")
    # Verify that the VM drivers are compiled in
    assert_includes info["vmTypes"], "qemu"
    assert_includes info["vmTypes"], "vz" if OS.mac?
    # Verify that the template files are installed
    template_names = info["templates"].map { |x| x["name"] }
    assert_includes template_names, "default"
  end
end