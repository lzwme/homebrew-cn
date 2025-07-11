class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://ghfast.top/https://github.com/alexpasmantier/television/archive/refs/tags/0.12.2.tar.gz"
  sha256 "57695108e34668cc32080f5baed57a1034b4dc606ed0730fac9fa1a6aaea68e3"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "610ea39f3ba4abf51f8d1b2f0ec00f5d14e225f44b4e088ca5d15d22635fe5f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e95bdc827ebbb2ad9782e11e8d254004b38cea0e6dcf3971e649d964136b808f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4fc13de1cd99734d22041de2ba0777fa646f0a29ffb43687b92bf7d65e98766"
    sha256 cellar: :any_skip_relocation, sonoma:        "6934f2afbd588b4a60f37d1eefa1006b113b592605741432981971824c0af7db"
    sha256 cellar: :any_skip_relocation, ventura:       "479bbe9c913f78ac9fce50c4adb22b1b38d3d26d518fc42262fca220c6eaf116"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "beb6980a183719f40e32ba90c88b401ec99ba8170b3ed631ade077b61e0ad23e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc9b991948a71ca6b117dbf01544c858b35fa00dde70c6e6e82d2e1c6943b06b"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/tv.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tv -V")

    output = shell_output("#{bin}/tv help")
    assert_match "Cross-platform", output
  end
end