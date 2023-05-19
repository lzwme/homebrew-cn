class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://ghproxy.com/https://github.com/erlang/rebar3/archive/3.21.0.tar.gz"
  sha256 "8025afe6ae88274f570e56886dd5dc25723a11fe31fe996e08e3f48edb7c5a63"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26e5eb3b328f77b040ec30ebf7ebbe4fc741c378b6b8068a5024c7fa92191299"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20c412f15eda103e882a793e794d5b73561c1e5d8acfca6ab833fbe6580ff979"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6663018e207c4eec22c594b9f79a58c2fef634071a945f2e79a9899b414b08f"
    sha256 cellar: :any_skip_relocation, ventura:        "ead47f23a4948aa57b593d27708ee04dab511b86b91dfc21b3abbc8a2ba20eda"
    sha256 cellar: :any_skip_relocation, monterey:       "14f62e871eb895d18e34da12d4b1f16c0b30fd125c9995779c28f0fa3fb3aa79"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1ef31d07d75c191da489b1b135dcd3bc310d66bf5c7c7312372be1607083fe7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfaa6089dcd4ef67209bf7e83d017cef3f5c58d2c58f365e70a4696344911ed2"
  end

  depends_on "erlang"

  def install
    system "./bootstrap"
    bin.install "rebar3"

    bash_completion.install "apps/rebar/priv/shell-completion/bash/rebar3"
    zsh_completion.install "apps/rebar/priv/shell-completion/zsh/_rebar3"
    fish_completion.install "apps/rebar/priv/shell-completion/fish/rebar3.fish"
  end

  test do
    system bin/"rebar3", "--version"
  end
end