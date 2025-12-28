class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://ghfast.top/https://github.com/ClementTsang/bottom/archive/refs/tags/0.12.2.tar.gz"
  sha256 "dff5064fbe74800f187d9846990be0431786b98c4aa49fdca8ff842efbb319b9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0234b7e3afa0db08215bc30aa8872a08831fc3dd5e9bea973650a575d69f4f3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa7a8b9736faf65d8470ff479ea6c8eb5eda18e6d310dfd3f6de5f9803e572ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a40fee46ebbd193c415dbe9ebf9cca6b056866886b60fa4ef6dfc31871f1b1b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "449125dc44507877ed1a37c5f6e972411e6428356f236669124c3fdfe510ab2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74793db01acf359bb7bc608c503a1f1e14bc0f007fc7ac915a0dd6a2701e1256"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbd00a71ee06a87ebb9fb492cae88bfc4637c1f821098df5ba5df178b657b820"
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