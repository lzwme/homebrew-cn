class Lima < Formula
  desc "Linux virtual machines"
  homepage "https:lima-vm.io"
  url "https:github.comlima-vmlimaarchiverefstagsv1.0.2.tar.gz"
  sha256 "f1f69d38998ca4e08b1dadbb3e3e5140feaecf8b49105a99a18be0e7a27ce90d"
  license "Apache-2.0"
  head "https:github.comlima-vmlima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de3712abd08d1f13939ef8f19fe556e581b810be4602d23ba82bc22a3f03bc85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cbe64ea673896c549a302833a754d33c1a1d777cfc8df9e9f634ce5bac6bca2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a063d7e643fe9d57b3dc58afcba3119ac7c55463deecbd8c8d3af51f0840afdf"
    sha256 cellar: :any_skip_relocation, sonoma:        "6438f090d5f9e933f3adf4d5d551458d2c2e62d5f81ba384cf49afdaa31f8611"
    sha256 cellar: :any_skip_relocation, ventura:       "1f5377e2c1b28d8f6d5f85e3c733293c20bc61baaeb696b9388038dd4ab6b0b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4eb7d507eacb6ecd19bc7d997f465e03898bb63ac1e8afba3be6068ab50d053b"
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