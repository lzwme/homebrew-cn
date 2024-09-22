class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https:elixir-lang.org"
  url "https:github.comelixir-langelixirarchiverefstagsv1.17.3.tar.gz"
  sha256 "6116c14d5e61ec301240cebeacbf9e97125a4d45cd9071e65e0b958d5ebf3890"
  license "Apache-2.0"
  head "https:github.comelixir-langelixir.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ca716d5a31bd16b8daf574510f0c6b7744b2e13a2e88a017de20165e37e75df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38df4be9cc5d53e09ab70d93e97472093e9e6687dea055fd877a8af2bd8d0c44"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b51877646bf0cb5aeee54c6bf77fb793960f150b9a79afe079d9fca41d94fa5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d97946b5a8f1fe6e51c6c681b403d0b19b42d919d57123ebcec966ae5fe35dd7"
    sha256 cellar: :any_skip_relocation, ventura:       "12e663933561c03c7cae89afc1856a46412098a29cb74e0ccb1a9d1515a00605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4a4676a658b0dff75250cc27efbaa5b7a97c9e6dc9940afd3d14ad0c5b1caf3"
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
    assert_match(%r{(compiled with ErlangOTP \d+)}, shell_output("#{bin}elixir -v"))
  end
end