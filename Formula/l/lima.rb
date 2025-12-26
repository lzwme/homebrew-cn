class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://lima-vm.io/"
  url "https://ghfast.top/https://github.com/lima-vm/lima/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "55625e642de492827e6cf7740c095822ef8193458211e286f17a3c11ebf50a93"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73210eeb5ea58a7a3c6694659c1caec7a28f7544dd7dcc2818d93486a906d4ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dda82893d81d727101d759eea2811299cd48d470cd73cdd61798568e18c01cab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c387213b8834107c87f40a0ccb7a7fe3e110467a999e5a12264116616b3b443"
    sha256 cellar: :any_skip_relocation, sonoma:        "395fe92acd723d415c65772e529f83e61f8c0a01cbea659f31845c4bce393fb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae25e1fe3f14e5308d70b11fb7542b1bf8443b86a33989587c3403b3a5e3ecc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e21d0a0fb0c5b7fdc127b322bcd97babce267d47bfa9ae374173e0034885646"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "qemu"
  end

  def install
    # make (default):              build everything
    # make native:                 build core + native guest agent
    # make additional-guestagents: build non-native guest agents
    if build.head?
      system "make", "native"
    else
      # VERSION has to be explicitly specified when building from tar.gz, as it does not contain git tags
      system "make", "native", "VERSION=#{version}"
    end

    bin.install Dir["_output/bin/*"]
    libexec.install Dir["_output/libexec/*"]
    share.install Dir["_output/share/*"]

    # Install shell completions
    generate_completions_from_executable(bin/"limactl", "completion")
  end

  def caveats
    # since lima 1.1
    <<~EOS
      The guest agents for non-native architectures are now provided in a separate formula:
        brew install lima-additional-guestagents
    EOS
  end

  test do
    info = JSON.parse shell_output("#{bin}/limactl info")
    # Verify that the VM drivers are compiled in
    assert_includes info["vmTypes"], "qemu"
    assert_includes info["vmTypes"], "vz" if OS.mac?
    # Verify that the template files are installed
    template_names = info["templates"].map { |x| x["name"] }
    assert_includes template_names, "default"
  end
end