class Elvis < Formula
  desc "Erlang Style Reviewer"
  homepage "https://github.com/inaka/elvis"
  url "https://ghfast.top/https://github.com/inaka/elvis/archive/refs/tags/4.2.2.tar.gz"
  sha256 "7ff3ef4693f635ec4e8f6cb80f22a055b130ca5505c07fe7b0ab19c00a78b830"
  license "Apache-2.0"
  head "https://github.com/inaka/elvis.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f488075456e0fe496ba31daa3b4464ac517a1ceb58a45be8c082dd85edfcaf02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43fa5e632f7dbad609f54c03105708c9e24863f679648c6c92edd1cc83f380d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ce301c19150868c1a316f6a3ab2e13ee91ecc9e400c091e8ab097bd97a45c16"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7b32ff93ace242c143bc999ce80b1b51c20287ce9b07be5a5441ed216518818"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eec73c6ab1db79543297c2776568980600e93d049f7e8dfd1a7f66cbde3cbb5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f50977c771610e1faa1a4b9c1f27479bcc0565af33e2cf61ca6078460218d77"
  end

  depends_on "rebar3" => :build
  depends_on "erlang"

  def install
    system "rebar3", "escriptize"

    bin.install "_build/default/bin/elvis"

    bash_completion.install "priv/bash_completion/elvis"
    zsh_completion.install "priv/zsh_completion/_elvis"
  end

  test do
    (testpath/"src/example.erl").write <<~EOS
      -module(example).

      -define(bad_macro_name, "should be upper case").
    EOS

    (testpath/"elvis.config").write <<~EOS
      [{elvis, [
        {config, [
          \#{ dirs => ["src"], filter => "*.erl", ruleset => erl_files }
        ]},
        {output_format, parsable}
      ]}].
    EOS

    expected = <<~EOS.chomp
      At line 3, column 2, the name of macro "bad_macro_name" is not acceptable by regular expression
    EOS

    assert_match expected, shell_output("#{bin}/elvis rock", 1)
  end
end