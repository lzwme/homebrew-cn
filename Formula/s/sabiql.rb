class Sabiql < Formula
  desc "Fast, safe-by-design, driverless, Vim-first DB TUI with ER diagrams"
  homepage "https://github.com/riii111/sabiql"
  url "https://ghfast.top/https://github.com/riii111/sabiql/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "745738d629b618f7f02190c176a89cebec29bfd3dd3877ebc12cda5223e8672d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81e0796b675dcd06e3468a587b2daf2ac1f33d000da3eb687be6cc16199e5d68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9be62b9b06b79cbd510197964bac174c6398c96a4f14c443669a6a1064f0fd82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb8b969ae276640a7fd4162d69889097a5f3c9e8ee179deeeae74104da7675bd"
    sha256 cellar: :any,                 arm64_linux:   "ce6016a6e24f92c123b29b080ca1cfbc3a2a7f9a7c57cb4ee5517c7e8add2ec5"
    sha256 cellar: :any,                 x86_64_linux:  "626f8e2ee7106c3e47ccedd1af8bf062a8356654e8b511416278989d73cabd28"
  end

  depends_on "rust" => :build
  depends_on "graphviz"

  uses_from_macos "sqlite"

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked"
  end

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  def caveats
    <<~EOS
      PostgreSQL and MySQL support require psql or mysql in PATH.
    EOS
  end

  test do
    # sabiql is a TUI application, so only its non-interactive CLI behavior is tested.
    assert_match version.to_s, shell_output("#{bin}/sabiql --version")
    output = shell_output("#{bin}/sabiql update 2>&1", 1)
    assert_match "brew upgrade sabiql", output
  end
end