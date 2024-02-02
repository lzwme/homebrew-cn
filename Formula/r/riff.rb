class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https:github.comwallesriff"
  url "https:github.comwallesriffarchiverefstags2.30.0.tar.gz"
  sha256 "9769656b4de2b55d07f773c7a09c2e051fa12c970685a1f363eea75c25764702"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "648e2e573598f2db2f67b1188200ce7dd61e0d01fc9052272fdcdf437383b6c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39ff01de732eea26ca75ad5da2b87aef867089b8a292a3a9c4f5a6312cf647df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74ea2048b094c0b8257cdbeda9b2e557f1406b3efb1bc3ca775ce57c54688e7d"
    sha256 cellar: :any_skip_relocation, sonoma:         "9632b049d74ecafbfefe8c9aafb4c78f72585e33e219ab4598425fd873189185"
    sha256 cellar: :any_skip_relocation, ventura:        "52d7a643021b0e0855143d6dd30dd5c61c0437b97f8c0269016c802884878d20"
    sha256 cellar: :any_skip_relocation, monterey:       "f57a5c1adeffc3f0f1cf88768051661535c35447d037e22ea4a409e141cf6b20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37f98d7c4887512904d42efd1bd85e65388055ec06fdfcd243bc911256d85f7f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}riff etcpasswd etcpasswd")
    assert_match version.to_s, shell_output("#{bin}riff --version")
  end
end