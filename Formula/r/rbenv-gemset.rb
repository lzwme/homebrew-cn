class RbenvGemset < Formula
  desc "Adds basic gemset support to rbenv"
  homepage "https://github.com/jf/rbenv-gemset"
  url "https://ghfast.top/https://github.com/jf/rbenv-gemset/archive/refs/tags/v0.5.10.tar.gz"
  sha256 "91b9e6f0cced09a40df5817277c35c654d39feaea4318cc63a5962689b649c94"
  license :public_domain
  head "https://github.com/jf/rbenv-gemset.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "ffb42742131fa52e3c5f707930c00e6af3fd6e069b4f2c5f492881d0bddb4945"
  end

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "gemset.bash", shell_output("rbenv hooks exec")
  end
end