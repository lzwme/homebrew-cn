class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://ghproxy.com/https://github.com/elixir-lang/elixir/archive/v1.15.3.tar.gz"
  sha256 "7dc895b09132d344948e05976bfbcdadf0884cda2a26ad4bda095b622d98aeef"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e890d9e3b5426ccfa557e5351b815c02e8a4173547799c87199b01a824f4b45b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1605af0837e7021276b47b3be04dc52136232323a17b183422b915b229ad106e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebb7bd03e52f02f3a5ee525baa5f63fd597838b8e25f121807084b5b5af2fcb6"
    sha256 cellar: :any_skip_relocation, ventura:        "717f14a156eeb6787ce49f6b5f862f8200a852c581556b7364e3c66ad69295f1"
    sha256 cellar: :any_skip_relocation, monterey:       "ee9f7ef329f3e3bb44776d5251b4fc1c92c4407f4baacd360a294850cf322620"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ebade3976164e1c74dfed975a47fd0ec16d3225b1056c1fdc2939692877cd57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72df1b4eea4eae2a6d3224c25cd3f200941491bd2e9ddcbe3e58273edc397e71"
  end

  depends_on "erlang"

  def install
    system "make"
    bin.install Dir["bin/*"] - Dir["bin/*.{bat,ps1}"]

    Dir.glob("lib/*/ebin") do |path|
      app = File.basename(File.dirname(path))
      (lib/app).install path
    end

    system "make", "install_man", "PREFIX=#{prefix}"
  end

  test do
    assert_match(%r{(compiled with Erlang/OTP 26)}, shell_output("#{bin}/elixir -v"))
  end
end