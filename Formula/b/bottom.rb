class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://ghfast.top/https://github.com/ClementTsang/bottom/archive/refs/tags/0.14.5.tar.gz"
  sha256 "fab3c85606973e3011241a420b012fc39525c6a5211fe1ad0b564b02b3ef165c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0effda796d89f61b8ab1124a3276a6bce26a3910da2ee3ced53d5f3e70447c5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "450ac20bcfe1fd8c90bb27cb92fa4e4e85b6195da9a31244154fc6ffc4aad649"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "277b50a396c6dca2769af1804c32a2e2f24ae7cbe6c194a978d692d44fb45033"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7279fea4a8cac477e1720d0e304a4c16d8d0611927879f5de08d91dc022239d"
    sha256 cellar: :any,                 arm64_linux:   "71f1f7958ce2715934a34731bc08fc4f9e32d99d5dd7f60c3a79d189de4f2934"
    sha256 cellar: :any,                 x86_64_linux:  "f44521ecca6519f1ebca3d56dc7245b11b4ef30963919b6b6ba126785a8e7c8b"
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