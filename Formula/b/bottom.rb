class Bottom < Formula
  desc "Yet another cross-platform graphical processsystem monitor"
  homepage "https:clementtsang.github.iobottom"
  url "https:github.comClementTsangbottomarchiverefstags0.9.7.tar.gz"
  sha256 "29c3f75323ae0245576ea23268bb0956757352bf3b16d05f511357655b9cc71e"
  license "MIT"
  head "https:github.comClementTsangbottom.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ddc0189ccf66af970eaace8442072a6b4fc3549099f70811c8fe49eaa653d436"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "767a3b5bc3ee69bbdaaaf8b71320ea93795da1387597b91286c75967fdca3206"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6fab0d7a1e322d68586a664ba30066bc2bd0f6fe1f069b2e865d7c18616d42f"
    sha256 cellar: :any_skip_relocation, sonoma:         "837c004767ea25431890e1a2186434dff17463b8290730bf0378e423fba8ce18"
    sha256 cellar: :any_skip_relocation, ventura:        "a4b093d689599cac6cb6980d89321caa544db5d1b4a8a068e57c960a989e9c20"
    sha256 cellar: :any_skip_relocation, monterey:       "a710710e02d61c21ab44462dc42a68025a601fc2c50de54f0d769dcf0ab1ea8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "972ea2c2796bdc51cbd28ad54f2a95d584092785ddfcc40a735e18b3721d3faa"
  end

  depends_on "rust" => :build

  def install
    # enable build-time generation of completion scripts and manpage
    ENV["BTM_GENERATE"] = "true"

    system "cargo", "install", *std_cargo_args

    # Completion scripts are generated in the crate's build
    # directory, which includes a fingerprint hash. Try to locate it first
    out_dir = "targettmpbottom"
    bash_completion.install "#{out_dir}completionbtm.bash"
    fish_completion.install "#{out_dir}completionbtm.fish"
    zsh_completion.install "#{out_dir}completion_btm"
    man1.install "#{out_dir}manpagebtm.1"
  end

  test do
    assert_equal "bottom #{version}", shell_output(bin"btm --version").chomp
    assert_match "error: unexpected argument '--invalid' found", shell_output(bin"btm --invalid 2>&1", 2)
  end
end