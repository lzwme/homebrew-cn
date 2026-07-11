class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://just.systems"
  url "https://ghfast.top/https://github.com/casey/just/archive/refs/tags/1.56.0.tar.gz"
  sha256 "145cb76ccd858da30ee56de884dad9241b2706140bcf9ae189dfda5e5a62ed52"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dceb6ba1f465169c7233ba4d88088d4762d1b702feed2f1a95cd3ac6f21a9fb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20a1fa468108698fe833f945338bb471e4ef65e2eb4c1db7f257c8a6dc42143b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d49435acd581cacfa95ae7ba0e21f8c6037d7cc8bde1c234984752bfe25196a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3122695a7a9cc8365ac23fdeb75a1ae7fb1f549de9f439cdf1b967e80e8c15e1"
    sha256 cellar: :any,                 arm64_linux:   "a6bf81fa756261bfed00c2172b9af9d18dfed2731038bdd5270d828a98654207"
    sha256 cellar: :any,                 x86_64_linux:  "93e607177f552f5c519a3f0b015fd88b9d7a763caec92c8855a3a5fd19f82c76"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"just", "--completions")
    (man1/"just.1").write Utils.safe_popen_read(bin/"just", "--man")
  end

  test do
    (testpath/"justfile").write <<~MAKE
      default:
        touch it-worked
    MAKE
    system bin/"just"
    assert_path_exists testpath/"it-worked"

    assert_match version.to_s, shell_output("#{bin}/just --version")
  end
end