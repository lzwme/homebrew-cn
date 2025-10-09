class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://ghfast.top/https://github.com/ClementTsang/bottom/archive/refs/tags/0.11.2.tar.gz"
  sha256 "213fbea68a315e012a0ab37e3382a287f0424675a47de04801aef4758458e64b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6728619f94b41a50bba7ff6ea4dac6cf0d9382d87f0ab031ae7b19149219bdf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9549e2c36e8d5e2c6e8206a96a0c94284c07f344a84536e2ac1e42bbbb2c47d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84f462b70ed48cf7e21c693927e44771d9d84a81bb4ade6eb3755a93223fc448"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b7d0d6cef2da08f34c7bbd680aa3aa2aab14d66f3240bbb1ed3e537b8bf7c5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2069e2513be1b1fea0bde7cc7e9f1c5e15c960ef5e09ccd2e3a29bfdc24d1e63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15e8b97b0c29324c1612a17cd3214035e8f3e681aa2094c8f6ac1cf5966038b7"
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