class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https:elixir-lang.org"
  url "https:github.comelixir-langelixirarchiverefstagsv1.17.1.tar.gz"
  sha256 "7567c7dcedd5e999d2d41bc2ff70626f49ec283af22eda4f347861bccb34c301"
  license "Apache-2.0"
  head "https:github.comelixir-langelixir.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a2ee85a9203877fca7d7f69227d1fddd179ab8e7e58fdca661fb3d29ac69f32"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75bea0574ae91ed6e34299ada95c2516e0bdf6f5ce0add0098dd2c88a413aca7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02d38fefc8bf7113fa633867dc4949cbd96aa06f946887e0fd8cce303da1e993"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd5999e44cf460a04623d3e693b9ad28e2650a98a1562eff3e72e68171f5e5de"
    sha256 cellar: :any_skip_relocation, ventura:        "2f772beea10a43c0b0849e5d2a05616ac2d997f3b04b4a1f527e263ab4ce0bce"
    sha256 cellar: :any_skip_relocation, monterey:       "c9ba1a2b489beff451ee79d8877865cae453053163d82bf59f555cd10fff1ac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f12173ac1da662f4d18f2e07e28968ed81eeca920bb8ba54e3a9800bdbba3b7e"
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