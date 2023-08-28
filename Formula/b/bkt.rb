class Bkt < Formula
  desc "Utility for caching the results of shell commands"
  homepage "https://www.bkt.rs"
  url "https://ghproxy.com/https://github.com/dimo414/bkt/archive/refs/tags/0.7.0.tar.gz"
  sha256 "1a846e163fa0c530d64a3fdd3935895a2e3b66a00ff099070bcfd1f0bdf1f674"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c454d031bb9cb8ebcf36b49137d4be6a2248d28dcb202a4a75047d92a4e511f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8342dc86fbdbf19564f772c038c361e232b8239412d3a52457cc437dddf8cea2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc939d9cc3cabb34301dffe4f8d63a112dd6637213316b9786b347ae23cab335"
    sha256 cellar: :any_skip_relocation, ventura:        "2182cf10cfe68da489b3bce17c190dc6ff0a60c0295b1dc6f07669d4a7ebe241"
    sha256 cellar: :any_skip_relocation, monterey:       "56b8f087e1ee3f7ec485ad47a628020a3566f9fe75cd1578ff3f665f8d81c884"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a220cdaa5cd9368270b2c7f4e5fc276b3b0dcfedf10819df4312441ee20a8e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3476550548768973aa8915b03350100d50a845e6d4f14aac64335fb26ccb3fac"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Make sure date output is cached between runs
    output1 = shell_output("#{bin}/bkt -- date +%s.%N")
    sleep(1)
    assert_equal output1, shell_output("#{bin}/bkt -- date +%s.%N")
  end
end