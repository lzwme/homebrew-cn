class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https:github.comerlangrebar3"
  url "https:github.comerlangrebar3archiverefstags3.24.0.tar.gz"
  sha256 "391b0eaa2825bb427fef1e55a0d166493059175f57a33b00346b84a20398216c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2fa23e681c8f8004bf426321acd2e05999906e798538ad1b37b68cc238633669"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "419937712d474338e34106bd9749cc373f7cde72523d11c352beaf1907f9d076"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2dcfd8009890e3bee785506b992ab88a6f0dc45cb520566f06bab1af44dc655e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "241c35af6b39043c65f7321b82fa36fb63b97cd9a0c817ae137f6816516e1d01"
    sha256 cellar: :any_skip_relocation, sonoma:         "84f894b593e9bbd52c471884bead7294ae0cb7ddc3b1e739f7b75bf6590d9c72"
    sha256 cellar: :any_skip_relocation, ventura:        "8e976eb647228e085d7ab954ae1bedf74bc050d02c3bee5193f732b996955004"
    sha256 cellar: :any_skip_relocation, monterey:       "60ac0ee45f7d74525400bf5607f4e21bc8e081152475d86bf7aae5606935dd1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cbcc3cff272dd00d92f36198dff1a98197423a1d544dd7388461498a299f357"
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