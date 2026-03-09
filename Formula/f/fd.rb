class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://ghfast.top/https://github.com/sharkdp/fd/archive/refs/tags/v10.4.1.tar.gz"
  sha256 "59ab83e56743e28eaa92c5497b3998a35744db6d8d574f389456481f2af1cb00"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/fd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56fdf12cdc4647c84ca021c9664e45175cecb3e7a4fc194ccb831f2dbe1ebc97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36792068f68abb85ca1275ec9ac4769a81133b411512857ff5cc5d6ca62e7cb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a804daacb4a815d31fd57b5a0fde24b636c976e1b67e6920a96b2926e788074a"
    sha256 cellar: :any_skip_relocation, sonoma:        "45928fb33bf08553e332f04057a01ef664236dfcac5374b1ce6eb6d835733179"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1402cdba22461e7466df78e1022f1b0d303550e32ae1952b702fb1a77e9b7c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0589a8f23683607004b922a8499a4af735eb43711e0f55d937d4611bb4b2ce37"
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