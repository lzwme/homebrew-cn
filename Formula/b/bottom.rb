class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://ghfast.top/https://github.com/ClementTsang/bottom/archive/refs/tags/0.12.1.tar.gz"
  sha256 "bfa6fdf969998a4cc6225a0d9b8867bce50ca2f579330974ac2e2fcaa59cc928"
  license "MIT"
  head "https://github.com/ClementTsang/bottom.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60c9df212cccca3b701ad92da6d71e66a409e07db50c1e56c8b91668352523c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25aa13d59ce992c1e033481266a6940b21db8909d4bd2a9f46db3aa1f438eda7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "773a33efadee7f1cd02e50c059cb96eadc50d3a1cb06012dd76ccd2b6526d043"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7854d88268ac8885194b492e051ca3c78b1c17b4e189962ee2ab2e3a67c1d18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0dface8106b3c4b3ca87df3245b8c2bb0d354ab8b833b1f7a01773aed815f7ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d4a2f10533cacc3a5ae5a9bdf6ee75c390e45df740d74bc5b838cc9dae4dd20"
  end

  depends_on "rust" => :build

  def install
    # enable build-time generation of completion scripts and manpage
    ENV["BTM_GENERATE"] = "true"

    system "cargo", "install", *std_cargo_args

    # Completion scripts are generated in the crate's build
    # directory, which includes a fingerprint hash. Try to locate it first
    out_dir = "target/tmp/bottom"
    bash_completion.install "#{out_dir}/completion/btm.bash" => "btm"
    fish_completion.install "#{out_dir}/completion/btm.fish"
    zsh_completion.install "#{out_dir}/completion/_btm"
    man1.install "#{out_dir}/manpage/btm.1"
  end

  test do
    assert_equal "bottom #{version}", shell_output("#{bin}/btm --version").chomp
    assert_match "error: unexpected argument '--invalid' found", shell_output("#{bin}/btm --invalid 2>&1", 2)
  end
end