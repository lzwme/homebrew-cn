class Lima < Formula
  desc "Linux virtual machines"
  homepage "https:github.comlima-vmlima"
  url "https:github.comlima-vmlimaarchiverefstagsv0.20.0.tar.gz"
  sha256 "935cb2816973c6b7bb8c19169d6f731a4a839cf636e53d78a1db09458784a6d7"
  license "Apache-2.0"
  head "https:github.comlima-vmlima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd850d005724dd767bc9dbfe4079f1b313d86795c3ad4c6b6db39ede0210fc1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a487868f8d4e647947bd663734579b5278222926882bf6a21ec989bb067c6221"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a16ff5399ed5a278d09935d9b066ccdb3ff328c7c8f1a51012149f71fb50b1b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "616317913d5b34b6cfd9716dc3102ef42c3335297d35aba9bf5777a2bfd08e12"
    sha256 cellar: :any_skip_relocation, ventura:        "0632da7796a2cfdc16a1752c9c41da86e34e564069e9e0e8aa072a4cd7efb91f"
    sha256 cellar: :any_skip_relocation, monterey:       "b6ac4cf7197a433496b82992a0900f52795512afdc8f065766c39b8415b7d14c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f483a5502f91c5d472a73984eae85dd8c39de4b65ce3de445d2fa0fbee3942d0"
  end

  depends_on "go" => :build
  depends_on "qemu"

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
    assert_includes info["vmTypes"], "vz" if OS.mac? && MacOS.version >= :ventura
    # Verify that the template files are installed
    template_names = info["templates"].map { |x| x["name"] }
    assert_includes template_names, "default"
  end
end