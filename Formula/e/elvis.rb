class Elvis < Formula
  desc "Erlang Style Reviewer"
  homepage "https://github.com/inaka/elvis"
  url "https://ghfast.top/https://github.com/inaka/elvis/archive/refs/tags/4.2.0.tar.gz"
  sha256 "4a3e33f3d3e787219d9877d7384d18b3687ab76c0387b0103251ad71965e22bc"
  license "Apache-2.0"
  head "https://github.com/inaka/elvis.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d789f15533335d5643132ad8947655364b3efa55bde9879534104c4598715a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16b90b24ea7dd3773c450a3430c0dde1e6f29a20a266478d791c0591733ef4f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a6a48d53e7fa9843e659888f69ce1b90e3f3110eac87585809f241a58169704"
    sha256 cellar: :any_skip_relocation, sonoma:        "39ebf946b3120ecaf424e710bf665c5a8bf4e7d5072c76c50a5479e9872f31bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "540b2116b3abd62bd707fb203275274307137b2cede2009cf4ae368ab9698702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "087901b78201cab8e8e0e0c2de4a37bc6855252bc36caafe764333c66c32e961"
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