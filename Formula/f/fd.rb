class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://ghproxy.com/https://github.com/sharkdp/fd/archive/refs/tags/v8.7.1.tar.gz"
  sha256 "2292cf6e4ba9262c592075b19ef9c241db32742b61ce613a3f42c474c01a3e28"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/fd.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "314376b1b9785b927ebcf15e7395ddba0a1dfc8d10752b39a1e989651a07c8ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cdd3ad4bbd6f7edcd82b7e507c513cb8693bcf37669d67e23c985e8667b0f43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee8dda936246d9b6280f06ef7cf861b14f37926777f8d3746ed1694372c05e34"
    sha256 cellar: :any_skip_relocation, sonoma:         "25ced192ca9dda96ebd8c52b4a944052a2147156ee10d01bb71211f1567ede17"
    sha256 cellar: :any_skip_relocation, ventura:        "5bd1806efd2a1a79f387951528d82ffdba547ed4194a76e334d8e219d4bff3b3"
    sha256 cellar: :any_skip_relocation, monterey:       "2c4c79a54ccd73e36730071793f42acbf8e39a262fcd6d26c8c6a52ef137ac2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b5cf8de26dcc9336857a3f93e9d66b92fdfe9aa874f697e8b579ed7bcde06f8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doc/fd.1"
    generate_completions_from_executable(bin/"fd", "--gen-completions", shells: [:bash, :fish])
    zsh_completion.install "contrib/completion/_fd"
    # Bash completions are not compatible with Bash 3 so don't use v1 directory.
    # bash: complete: nosort: invalid option name
    # Issue ref: https://github.com/clap-rs/clap/issues/5190
    (share/"bash-completion/completions").install bash_completion.children
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "test_file", shell_output("#{bin}/fd test").chomp
  end
end