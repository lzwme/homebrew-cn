class Lima < Formula
  desc "Linux virtual machines"
  homepage "https:lima-vm.io"
  url "https:github.comlima-vmlimaarchiverefstagsv1.0.1.tar.gz"
  sha256 "82e9bfcfdf7423baaf4c712a3123237818c26b0f22abb38b73591b28a36b754e"
  license "Apache-2.0"
  head "https:github.comlima-vmlima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8693150976531f9cab032843cdeeb80f7190d2f20dc0af80884a6f80bfc841e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51a7484094c23bb3d13b78dae28c406601ccdb3b430b90fd4fdba9b26cc36c0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13d732461047d45acf457ef29590fcbb3a1c6c3e14632bea3f8c7f30e2f289bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f83dc83a67c6375d59a72231d4898dc2067694160e4d70ca0da277b2df5a19c"
    sha256 cellar: :any_skip_relocation, ventura:       "9b6281c4c8859507936289ee44b2d1be9b7d1b5b1b38cf5246c1ce41801e74e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f7287671de8b02363b8465a6db3ac191faa52bfc793504f2ec050b0eb99ba17"
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