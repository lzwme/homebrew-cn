class FzfMake < Formula
  desc "Fuzzy finder with preview window for make, pnpm, & yarn"
  homepage "https:github.comkyu08fzf-make"
  url "https:github.comkyu08fzf-makearchiverefstagsv0.58.0.tar.gz"
  sha256 "54496764a55d6cbd3ab76135dab7b0b07384a698c70d19ba8a6abfdb7d9d2792"
  license "MIT"
  head "https:github.comkyu08fzf-make.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8617ca6580060a598d7b855382271906f7e427e66fbcc9b6cb914c0a425d09cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4d28928aee0e73b62cdb09567ab660c5ce38c88941199caccd4865a6fb2ffb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "117f6aa1fbe29e37979c73def722124a87ae5e235b3267221113bab3bdef16e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbfb21e4f3924237e1679cfb8d6ca7a057e0e69b2776c7f4e21102072d6cb9b7"
    sha256 cellar: :any_skip_relocation, ventura:       "1c50504540ea917bdbe077051d6d253ce8223b0866ce87265fb845899b912813"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e5070510f3b3c845e55c4de6ee7096705afd07e5c09a0ab7b15745e22b6ab98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4bd94ed3ca50c09d5b7f78335e5917eab12a56379a3c76ddbc690bbbabce5ab"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}fzf-make -v")

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath"Makefile").write <<~MAKE
      brew:
        cc test.c -o test
    MAKE

    begin
      output_log = testpath"output.log"
      pid = spawn bin"fzf-make", [:out, :err] => output_log.to_s
      sleep 5
      sleep 5 if OS.mac? && Hardware::CPU.intel?
      assert_match "make brew", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end