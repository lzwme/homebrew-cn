class FzfMake < Formula
  desc "Fuzzy finder with preview window for make, pnpm, & yarn"
  homepage "https:github.comkyu08fzf-make"
  url "https:github.comkyu08fzf-makearchiverefstagsv0.47.0.tar.gz"
  sha256 "93199143b5364e4606aeb6859ff81e28d080d53250534cd60d2d5badfa96c8c8"
  license "MIT"
  head "https:github.comkyu08fzf-make.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76a75a5a13c8634a83f88663c0e94b4119f16e82296c4dbabd729507b3c31005"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e769a89d54edb24a60320fa9dccf649e716015682f77cc66388b7b379077e24e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a8a9eee75f5fe27df80f7bab64ec129cfd317ecc48c99ee6d27d945a8a79294"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a2bdbc641e0b94b05182c26ab1e77356cc4d5030ce4ba1f3db9f6cc2f3dc467"
    sha256 cellar: :any_skip_relocation, ventura:       "90fc69701b6592e7a2216b6e78a79f3237f487883edca60899de097b97f77a9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a4293cb6cc8f2502e4fd0b0de53422d1230c459c47243810f874bba7bc881d9"
  end

  depends_on "rust" => :build
  depends_on "bat"

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