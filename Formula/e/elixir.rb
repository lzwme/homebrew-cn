class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https:elixir-lang.org"
  url "https:github.comelixir-langelixirarchiverefstagsv1.16.3.tar.gz"
  sha256 "a163128e618e5205ea749f8effafa5b540008fd0bed863e75e2e09663a00ec45"
  license "Apache-2.0"
  head "https:github.comelixir-langelixir.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e99addb10343d3fc64ab491cf52aa8480dac2ad9c7f4aec7cff192bedf20cdd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9fcaeb0f5b29b03ce87fa36e3b5d2dea6d036dab8fb296a8f5668bafb058650e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed00ef83ec15f2ac4e5d77bb04d15200f398f1999ebf2761a2a733d4e9a30b30"
    sha256 cellar: :any_skip_relocation, sonoma:         "a129853cd793c522b09470d1b3c3361ee6b312391ec8e64242cc6869fcbba273"
    sha256 cellar: :any_skip_relocation, ventura:        "569a2f6e835a809ead8165236aeaa9522b8053b305f844a765e6b0779f4e0268"
    sha256 cellar: :any_skip_relocation, monterey:       "1c63469cadc0f1df7308535e1db7ae32260e37ea1ecf1db005b6c33a8e86f105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2abc282e6a89acc619e0332d7e0988f94e3fc81e8daf2e0c15f1a148778b1a24"
  end

  depends_on "erlang"

  def install
    system "make"
    bin.install Dir["bin*"] - Dir["bin*.{bat,ps1}"]

    Dir.glob("lib*ebin") do |path|
      app = File.basename(File.dirname(path))
      (libapp).install path
    end

    system "make", "install_man", "PREFIX=#{prefix}"
  end

  test do
    assert_match(%r{(compiled with ErlangOTP 26)}, shell_output("#{bin}elixir -v"))
  end
end