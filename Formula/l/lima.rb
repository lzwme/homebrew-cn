class Lima < Formula
  desc "Linux virtual machines"
  homepage "https:lima-vm.io"
  url "https:github.comlima-vmlimaarchiverefstagsv1.0.5.tar.gz"
  sha256 "8087267177549aaa695178431e5ef02eacced0802927004d6bb066afeff5b4e8"
  license "Apache-2.0"
  head "https:github.comlima-vmlima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbc4ecf79d33fbd23503df159b1f7d814aebac6ed05cf3dcee33a77452c7879a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b31bbeaff8f5cce6b9ef69bcaf58a4db54d703f3f5f39cdc21cebe6996e9cdab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97772fe36f3c4fc1ccba8505b15e715bba7df098b9b5594359fa6ded51392710"
    sha256 cellar: :any_skip_relocation, sonoma:        "02554cd4be487485e14058a1a024f1b6301c62890bac4f10fe8ef0037ae367aa"
    sha256 cellar: :any_skip_relocation, ventura:       "9a1a91e1b052f8936db29100a89d7db95e4f7c3dcba406e5a2fd991ec9e68d88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9df1924e1d8e48f03c04307a973fde78a98a10a164e64dbee9f9f1aecb716263"
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