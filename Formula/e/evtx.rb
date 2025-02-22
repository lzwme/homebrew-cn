class Evtx < Formula
  desc "Windows XML Event Log parser"
  homepage "https:github.comomerbenamramevtx"
  url "https:github.comomerbenamramevtxarchiverefstagsv0.8.5.tar.gz"
  sha256 "92076a952e0d83efca42510c394c14a3ee890a47443b8817551fa41900eada9f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comomerbenamramevtx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bef159b9169db2ae541024747e85de777067ad171ae0a886943e9bc381ad437a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71a7b4ed63d058ec4de6a9127a8cbf0720c67ed5431982a28f009bc3133fe0b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c54f551f83186d2d65fc115074e47710ef97babd94283a0d806e87b699c4a83"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fa5b33c6b3a68448ac407f76abd8f60abe67f3d4b07fc436a0d7cf56ba50fa1"
    sha256 cellar: :any_skip_relocation, ventura:       "1058939b3480ace731749a40d0974835819edfc8a06274639900bafa98957c30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c1daee91c9958cb11e0c6cbe29a78f7a647a2a0d91d2fd1b8e1c3e8f5c92530"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "samples"
  end

  test do
    cp pkgshare"samplesissue_201.evtx", testpath
    assert_match "Remote-ManagementShell-Unknown",
      shell_output("#{bin}evtx_dump #{pkgshare}samplesissue_201.evtx")

    assert_match "EVTX Parser #{version}", shell_output("#{bin}evtx_dump --version")
  end
end