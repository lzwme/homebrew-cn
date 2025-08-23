class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://ghfast.top/https://github.com/sharkdp/fd/archive/refs/tags/v10.2.0.tar.gz"
  sha256 "73329fe24c53f0ca47cd0939256ca5c4644742cb7c14cf4114c8c9871336d342"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/fd.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0062840ffe4426b5487ecf093917dbc5ffb15a16266e3144803c4f784b62c192"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0226d4c24ecd6d3e68ae193f85b5f180126f50f82607eec4ce375b2154ea161"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9783ef7681c7f19934eb58b8bd11495025a2e327b726e68940872a26a51ef0bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "687a43155f651390be9b9a65399d64cdb2040142a7ca34286217fc56e700289b"
    sha256 cellar: :any_skip_relocation, ventura:       "057cd47107f9c4b6d80c6de29e13d2f33ae793b4c3ae789b9fd9f58f3dc41127"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bd14056b8ab967763375e7d8accf2bea48f0eb71d970c7c0c9062a62bd84395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ba51355cd0ccf8435d98d425216a063f27d75e079e1b4b5c376a23e4d3df3ad"
  end

  depends_on "rust" => :build

  conflicts_with "fdclone", because: "both install `fd` binaries"

  def install
    ENV["JEMALLOC_SYS_WITH_LG_PAGE"] = "16" if Hardware::CPU.arm? && OS.linux?
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fd", "--gen-completions", shells: [:bash, :fish, :pwsh])
    zsh_completion.install "contrib/completion/_fd"
    man1.install "doc/fd.1"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "test_file", shell_output("#{bin}/fd test").chomp
  end
end