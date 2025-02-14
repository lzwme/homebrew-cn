class Lima < Formula
  desc "Linux virtual machines"
  homepage "https:lima-vm.io"
  url "https:github.comlima-vmlimaarchiverefstagsv1.0.6.tar.gz"
  sha256 "16077e869cf525003c9aacd2290dadd5e966b0d0ab8ffdb69c13836610526526"
  license "Apache-2.0"
  head "https:github.comlima-vmlima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd5d16c2ed7eb78905faa12dbf1501b9445b3650bb8e6d669629e4681462e9d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5436e4a1e9f2f5c179b30d0cd30b7d8c5c55599d778cd82b8ef4408e15ccd176"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91df67816d5a473b652ceafb684be9113ae4dc05e2fbc767be8049e5cc182897"
    sha256 cellar: :any_skip_relocation, sonoma:        "884ad976b52c8ee1955460018a918e98dc854e5ce04f1b32473efba262b4b76e"
    sha256 cellar: :any_skip_relocation, ventura:       "9b592ba42fe9feeadefc7e22f71dc4b96529206c1d488c4ca040496a160062d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63233708236fa96e57b263d93250e5a66c2cd1546f2b5196dafc36657fe45f03"
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
    generate_completions_from_executable(bin"limactl", "completion")
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