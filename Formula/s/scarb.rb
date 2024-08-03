class Scarb < Formula
  desc "Cairo package manager"
  homepage "https:docs.swmansion.comscarb"
  url "https:github.comsoftware-mansionscarbarchiverefstagsv2.7.0.tar.gz"
  sha256 "9ef9b3a2242f9b951194effc2b087a62cb2947d4ac6af5f90c974d6eefc400d5"
  license "MIT"
  head "https:github.comsoftware-mansionscarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae80c07df623edbeb98f4283e43199afea3538a00cd58fc15ff9da1147741c20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27478800bb22a021035d14901ff27759058bf7adc23f55c2a71644f511d0f9ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af26ab0b048af9b1c856c4cdf7536c6b7041daf9beb8edc4eac3609ca461abfe"
    sha256 cellar: :any_skip_relocation, sonoma:         "23018f741fe56957e76704c219a8a07b2bd93faa9181d3d8cc3d3812effaad92"
    sha256 cellar: :any_skip_relocation, ventura:        "043117caeee18f76eab52defb646cfef3a117c6b993953aaa76f182198fd5135"
    sha256 cellar: :any_skip_relocation, monterey:       "5cc03112185f53f5081764853c1c6df86af855b5cb1368edc4fcb61dc0dfb5ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4de2e0158ab9b8972e12a3672de46bfb006e035f3177b16dcb2d73963aaebd65"
  end

  depends_on "rust" => :build

  def install
    %w[
      scarb
      extensionsscarb-cairo-language-server
      extensionsscarb-cairo-run
      extensionsscarb-cairo-test
      extensionsscarb-snforge-test-collector
    ].each do |f|
      system "cargo", "install", *std_cargo_args(path: f)
    end
  end

  test do
    ENV["SCARB_INIT_TEST_RUNNER"] = "cairo-test"

    assert_match "#{testpath}Scarb.toml", shell_output("#{bin}scarb manifest-path")

    system bin"scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_predicate testpath"srclib.cairo", :exist?
    assert_match "brewtest", (testpath"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}scarb --version")
    assert_match version.to_s, shell_output("#{bin}scarb cairo-run --version")
    assert_match version.to_s, shell_output("#{bin}scarb cairo-test --version")
    assert_match version.to_s, shell_output("#{bin}scarb snforge-test-collector --version")
  end
end