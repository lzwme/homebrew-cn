class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://ghfast.top/https://github.com/ClementTsang/bottom/archive/refs/tags/0.14.2.tar.gz"
  sha256 "40fae71b665bc9bb84f42ddeb65d12c09d689cd155680b93e5aaabdfa28cecf8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d97caaf3aa452876946e54d43d0cb148a3dd2fd9f6eef2ba277398ec7e2c752"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "949424b2d4713ed585bea874f506020bc1ee606bb73693e8cf63f910fd4fb217"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "084ecac078ab23c655305905f68df372d235d071c74e5d68aa9e481d8f0b4a75"
    sha256 cellar: :any_skip_relocation, sonoma:        "e29da190a3c03a0e4dbb1eee2499f07f4a81771a5cdccc8eef2aaf4d2f9338d6"
    sha256 cellar: :any,                 arm64_linux:   "75b00ea6ffe8a0039c1cc58c7946c95392606d3bb01a3de3fd8d4de83a79d274"
    sha256 cellar: :any,                 x86_64_linux:  "24619532b4af9a545d33d992089f6030363b531b5085bfd6a8623f4917871abe"
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