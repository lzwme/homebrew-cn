class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://ghfast.top/https://github.com/ClementTsang/bottom/archive/refs/tags/0.11.0.tar.gz"
  sha256 "66b23ac0dc3ead78becf052abb0e3282922c7977f2e85eeb54dc9f7be40d5599"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3422edf81395eba20a5cc406f74adc6ed8c3311779877fefbdb247469154a1c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb7b26851c8a72909c85be6409af0a621daca1e253c51e3a8388b7f6531695a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b375f6a3db7801902245eb493dc72eb7e13b397d34c5ed6bf7efd60473fda685"
    sha256 cellar: :any_skip_relocation, sonoma:        "70748e2e6e9ddfa528da63da2d6005ee6621659d64e8356d99bba27f34b48c8d"
    sha256 cellar: :any_skip_relocation, ventura:       "bfb212bd9b8b003446efa6d68b6095e5a7ffc0437cb00d62962c898792fe9a46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5dcefd23d2645d7ed7ef9cbeeacbae338f0f168798602a0aaf436e2a964c23d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df6f699ea4f0d8ac21cfcea3c28caad5ed02c7c46cf8c841a25b7be0995642d0"
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