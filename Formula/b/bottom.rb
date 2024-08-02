class Bottom < Formula
  desc "Yet another cross-platform graphical processsystem monitor"
  homepage "https:clementtsang.github.iobottom"
  url "https:github.comClementTsangbottomarchiverefstags0.10.1.tar.gz"
  sha256 "c0e507cc3a5246e65521e91391410efc605840abe3b40194c5769265051fa1cc"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eedb62de704cd160bc387e0df8b98f79525f4942bf11434a16adf963c6b4e1eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "967c4f6458f98e441a173b2682c6d9e328ffe01fd3ca6aa586883bfc849f2f0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e29a2c3ea6204ae3523cedc6260b18d7f232fc812dbd240c8c6bbeb497de3f40"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a2d09c039a6cac8d729b5b4650eba43af34eebb77b0807c4ed64214a64b10b1"
    sha256 cellar: :any_skip_relocation, ventura:        "f2b3aa0c4bba40944686070ab14587f22fcb85a1e3b5501a495a16d9b0cf2f4a"
    sha256 cellar: :any_skip_relocation, monterey:       "74f3492d94351fb7901453ec17cd3242a17e045283e46a429207896bec92ecb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b24cdb601d4b21233ce852c5fa15acbb30c1554dd8223c502b2e2fe9c1c966f"
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