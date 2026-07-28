class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://ghfast.top/https://github.com/ClementTsang/bottom/archive/refs/tags/0.14.7.tar.gz"
  sha256 "249fca780922460278fffa2c3697a30c8a5483d06c14e66f093f51234d49c50c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e5dbc9bef3c6b757e2c06230364c0979b4624452315171de252731ee767c938"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b5e454048cdff98c60a3f3abd7c76202e98d7ddbfb66f3c1ae7e2c5580d29f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab93a48ef57752309262a6041042c88c93c2185ca9d3a945e4a378eaabd3d7a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1184c3172c9160dff1265553f40db84e220b53485c99e40cb00261d0680dc3bb"
    sha256 cellar: :any,                 arm64_linux:   "30210ee9871dd9cb4773f7e218bee2c31ce6c16274ea8afe86220afaf440cbce"
    sha256 cellar: :any,                 x86_64_linux:  "b2edcb77c0a51067a0669c396400fad6db19d84cf694fa7cfe095ffdfb802299"
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