class Elvis < Formula
  desc "Erlang Style Reviewer"
  homepage "https://github.com/inaka/elvis"
  url "https://ghfast.top/https://github.com/inaka/elvis/archive/refs/tags/4.2.3.tar.gz"
  sha256 "60ba94dff69713daa740f15ae45b79d8bba18c4d8f35dcab537f878affb7ddda"
  license "Apache-2.0"
  head "https://github.com/inaka/elvis.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "551cc88ecfc33cdfecb2138c77ca8b4c0f14f9e712488bf95a8b9bf4e765506a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "979f4048c2a74eb79a184ece21025d8760133a0e03c9b37be1977c379f0cb01b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91c9050d9276a5fe6557eaeb2c6bc612372e1d74d6bd65bb937082bd23e3a921"
    sha256 cellar: :any_skip_relocation, sonoma:        "630aba5dccdcbf486b7235fca0761a2250b92f98cabe342b115f2ea34fc4e9f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cad07c1479fcdfdf0ab30ccbda3c044ae5f486d538c54c096ebf72dbed653c96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "659554212c607dc64c72386b0f87b7f5f53de83a2f4afb65a9f38b9ffbc4c8d8"
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