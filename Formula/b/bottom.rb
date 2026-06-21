class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://ghfast.top/https://github.com/ClementTsang/bottom/archive/refs/tags/0.14.0.tar.gz"
  sha256 "6509dde9477f4a83dca2cced99b09d6b89ec378aff99dab2eeb30e76d11a5df8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e5e76cf1cedf543164c2cce53c71963865b2f42b8a75a4a638bc053f0e0e8cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cac1b5b1d9dca7acf6e8a9d0c4dc4b943e96788760e3164abfeaff087becf2e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "028017a72d2e06b67d220cdbac5bf82ea9de79f5918e1ef796dac74563d0896d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fc62e7986138803b6db43db1f7170f593c4cd670ab47245d9208a5179c4effd"
    sha256 cellar: :any,                 arm64_linux:   "e8b500c2b694b2a3a138a4201566826107006df4b46c99adaa2b0f1b74268ac5"
    sha256 cellar: :any,                 x86_64_linux:  "e5495c30868e4715511ee4a1c4de206b81aaa0e34a7fc34a90a12adb61d498df"
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