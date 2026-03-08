class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://ghfast.top/https://github.com/sharkdp/fd/archive/refs/tags/v10.4.0.tar.gz"
  sha256 "9caf8509134fe304ce5ee4667804216d93fe61df11ff941f48a240d40495db16"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/fd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e036c2f80f6edaab1e76e1e1d5c647d525394ef4c597fc1a83f1751f7286e37c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b75b6b46bdf5b9820ee1c3cbaa8f3c156e6ab2895eb2ab29f6116d26614adede"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb10f2bae5253b8d9f80bdae686abcb4a382887d641e51e7d6ef8dce53fdd2ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "3062163d9a25a5b802bae2e0f123f782d49940b48d7c03d59862d4245de43dfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2095e41dcf09f947f9a9aa274d99df788a96f683b54dc59c98c48f110321b8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f55366b3b28255ebc9073cdd14fdcfbe22f600024a95c40c7d6d94532186bc0"
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