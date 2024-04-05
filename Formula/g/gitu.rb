class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https:github.comaltsemgitu"
  url "https:github.comaltsemgituarchiverefstagsv0.13.1.tar.gz"
  sha256 "e4eb4fc8444996878f894f35494cf1a72a1a530b8a84094d535143729547f405"
  license "MIT"
  head "https:github.comaltsemgitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6b2f925c3ece7c3a964882f9256b67eca292e038ada1cfaf7e09c76acf75b90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75654e450d78d360768925101c5cce5b7263de6dc462b16690d48dbc28f20f41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53390002d6a450e91814efaf5139de85ed1389504ba4e8e6f60d4ea10af2d526"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a25cb621a0ec51137826100814083328cc93a8790730f9e159107e40682c97e"
    sha256 cellar: :any_skip_relocation, ventura:        "49c583e0de903eb3ac04dbb0d2d540bdf4a34f199b3bb4bcc410410ec0f51f2c"
    sha256 cellar: :any_skip_relocation, monterey:       "aafbe52826fa4503605fb3e0bec048830ea7c302b26c5d65db079bdd8a6cb81d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f324231410d499dbf99968bd98b15c024ec2fd4d55e5896b2733fd8a45b00825"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gitu --version")

    output = shell_output(bin"gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "could not find repository at '.'", output
    end
  end
end