class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://ghproxy.com/https://github.com/ClementTsang/bottom/archive/refs/tags/0.9.5.tar.gz"
  sha256 "538a8fce1f9a65c1c84811f0b89db083301fea06364ff725cca1a776b9e4ee3c"
  license "MIT"
  head "https://github.com/ClementTsang/bottom.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efe557454051d38baacb9e66c747261c2f5c6f5af69cb3d065dc0751178b53e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6e9ca0e2274ba202e35f5f0cd26a89537707db73b4c684a63c750ed26eb0e90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27f5cd867bdd381a584f3483c7223b71394841c62b37c361a228e2310b0e0ba1"
    sha256 cellar: :any_skip_relocation, ventura:        "a6a96278d544392853864230957830be6c773b925b05e58653148f0163dbbb15"
    sha256 cellar: :any_skip_relocation, monterey:       "e42bd3f6b4a79e014dee08f49b68985d3c9f8eba5cddce271079894f37477212"
    sha256 cellar: :any_skip_relocation, big_sur:        "8316cd23ef88c0214973fdcdf796fa2dcb0e492c44105df45751b0ffb150d92c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15ef03522757d95f9a16897e5064c1ad0124f8e2a56ddde791cdb37e105bf792"
  end

  depends_on "rust" => :build

  def install
    # enable build-time generation of completion scripts and manpage
    ENV["BTM_GENERATE"] = "true"

    system "cargo", "install", *std_cargo_args

    # Completion scripts are generated in the crate's build
    # directory, which includes a fingerprint hash. Try to locate it first
    out_dir = "target/tmp/bottom"
    bash_completion.install "#{out_dir}/completion/btm.bash"
    fish_completion.install "#{out_dir}/completion/btm.fish"
    zsh_completion.install "#{out_dir}/completion/_btm"
    man1.install "#{out_dir}/manpage/btm.1"
  end

  test do
    assert_equal "bottom #{version}", shell_output(bin/"btm --version").chomp
    assert_match "error: unexpected argument '--invalid' found", shell_output(bin/"btm --invalid 2>&1", 2)
  end
end