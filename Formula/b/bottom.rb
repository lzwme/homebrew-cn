class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://ghfast.top/https://github.com/ClementTsang/bottom/archive/refs/tags/0.11.3.tar.gz"
  sha256 "f5d286c2950379a310be2042271c4bd772ef66947bf1ca16e5a169115774745c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2cb872bc6bbee562218c06b04ff3bebac0c5284f896d95a10f6c75a134c9e07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09ee6a3224c00129a18715a06c07bcf5a46c74cfa3ae2e381765717384015e29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fcafd5244179840eb68fcd390b92860dbb94bc1094110865b7d03af7cf5c9d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3756ba055f68beb1cada7c43c261af16d95cdbd82e17d6d526ed4d676dd8eb0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd6a3957a290760ba7e4b78a4f9e9c94d02483124eb0265b410bfe9036fac89b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b412d131eda296e8ce1d183f60fce0730178b93819007cb3fe08fdcd88afda75"
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