class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https:github.comajeetdsouzazoxide"
  url "https:github.comajeetdsouzazoxidearchiverefstagsv0.9.5.tar.gz"
  sha256 "1278660e671d96c5421f0910fa7d79b9e0bb0bfacf7611ff63bf383f721d7a4f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0e102c4e59ce27b3005913845e86dfcbdcfdaf8710d045cdc84135f4f01e9b25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2782ff76aab33b4547459df4a5b5b75aa21cd59cd9c2340d125df209b1a7a86b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9598bcf639708d5cc90c60407793d131e774e3caf675ddd47774c56990251022"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "346c9c69784b805b5b6c2d0116937f82be2372cfe5c30b1f61845cb46b95a48c"
    sha256 cellar: :any_skip_relocation, sonoma:         "5fa33cf03f4b8eedf16b1cd80e1eccd7102622afc76d9c6ba99823da17049ff1"
    sha256 cellar: :any_skip_relocation, ventura:        "322bc9f0aaa85681027ed76921b21f952f99da9992ff3ac8972bbccccc5f2702"
    sha256 cellar: :any_skip_relocation, monterey:       "4c405d72427c77dce8fd1fe7f99584dc4c4a018845be66e8ffdef7e85d721505"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3946c218d57cf2d574d57161ca65e19ff2f9faf6de666cef6adf183ae7f8b5a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "contribcompletionszoxide.bash" => "zoxide"
    zsh_completion.install "contribcompletions_zoxide"
    fish_completion.install "contribcompletionszoxide.fish"
    share.install "man"
  end

  test do
    assert_equal "", shell_output("#{bin}zoxide add ").strip
    assert_equal "", shell_output("#{bin}zoxide query").strip
  end
end