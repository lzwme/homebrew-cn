class Evtx < Formula
  desc "Windows XML Event Log parser"
  homepage "https:github.comomerbenamramevtx"
  url "https:github.comomerbenamramevtxarchiverefstagsv0.9.0.tar.gz"
  sha256 "c9e827afd315c235873b6848a9c7ced0d5434225e1af391f8c9c66b63d7349ad"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comomerbenamramevtx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ca10a7b7bbd193f2db9cf344c6e07a71552fd72f1386f76f33391a82a9d119f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d810671bd7012ed66945b01d2c73e15668d112407a30918342762117b8e679a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9eb3466349cb0e14eb14166011465b4e213cf919b7a15dd401dd547975c86ab0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e5230b4025e7162fd560d2a00be6929318cdf3cce787b67bc43c7d970db79ee"
    sha256 cellar: :any_skip_relocation, ventura:       "1553061f028b829f448e09ee1be671ffda594fcd12962e5139f2f6b4b67fbcc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e5687bb7fa3754379bc85f008a8433f50ad6d41e3940c0153e4950a865517ed"
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