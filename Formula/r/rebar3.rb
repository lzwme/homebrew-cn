class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https:rebar3.org"
  url "https:github.comerlangrebar3archiverefstags3.24.0.tar.gz"
  sha256 "391b0eaa2825bb427fef1e55a0d166493059175f57a33b00346b84a20398216c"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ceccb36cd664e34d69823f3ba77770da10c70218d69caafdb34ee3db3ce250b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68f8359445c350d021027633edf70f572f3000fee53b08142c0dd73169519072"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f03cb9f3147876e10e2cd56dd8cf315b9f8b2188f808e8ad6018ab32839b0ea9"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c594f2b5a402ce44c8e55951d96e04e1762f2c3b054a6784da5172eb646e3fd"
    sha256 cellar: :any_skip_relocation, ventura:       "7bc1cf24e4908fe6a41942ca8aaee98641d3b645a28fd31e9727e0ca0bfd9904"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3049b6e29c6f38ac6ba4bbdfbdfd65e5a08e978b739957601c02aa6791cea5a5"
  end

  depends_on "erlang"

  def install
    system ".bootstrap"
    bin.install "rebar3"

    bash_completion.install "appsrebarprivshell-completionbashrebar3"
    zsh_completion.install "appsrebarprivshell-completionzsh_rebar3"
    fish_completion.install "appsrebarprivshell-completionfishrebar3.fish"
  end

  test do
    system bin"rebar3", "--version"
  end
end