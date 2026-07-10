class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://ghfast.top/https://github.com/ClementTsang/bottom/archive/refs/tags/0.14.4.tar.gz"
  sha256 "c2b2a5bf438d014b2a32fbbd9edc2da634cbdff4b01a2810d5dcb571d3998051"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82c5621d6d0bc8bb06d28b77bb6de1eea336749eda08f2e6a480b684b5b14051"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfe784f1e52f3331d7c82decf5676ade42d6d3cad39e53fc0f54ab6de0b66309"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4200b40ce36a9863743123b95e5574a62e8245852654b3fd94f2183c8be16784"
    sha256 cellar: :any_skip_relocation, sonoma:        "3807e19ff6f3790017569eb4124c7ee3d1a90844607be80e18acd65689db109e"
    sha256 cellar: :any,                 arm64_linux:   "28d947f5938d9a7885ad695b33df8bdada0b556c6e2d60b8412ea9d659ca344e"
    sha256 cellar: :any,                 x86_64_linux:  "d13044d540d4f0f69167c991c6120d14a0f494a3815c94e935f74156a3a77f8c"
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
    pwsh_completion.install "#{out_dir}/completion/_btm.ps1"
    man1.install "#{out_dir}/manpage/btm.1"
  end

  test do
    assert_equal "bottom #{version}", shell_output("#{bin}/btm --version").chomp
    assert_match "error: unexpected argument '--invalid' found", shell_output("#{bin}/btm --invalid 2>&1", 2)
  end
end