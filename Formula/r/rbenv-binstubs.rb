class RbenvBinstubs < Formula
  desc "Make rbenv aware of bundler binstubs"
  homepage "https:github.comPurple-Devsrbenv-binstubs"
  url "https:github.comPurple-Devsrbenv-binstubsarchiverefstagsv1.5.tar.gz"
  sha256 "305000b8ba5b829df1a98fc834b7868b9e817815c661f429b0e28c1f613f4d0c"
  license "MIT"
  revision 1
  head "https:github.comPurple-Devsrbenv-binstubs.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "cf92d2a4a872f49ddf33d4e4132ab0d1de390bf0c027a0f0e27925110bb01fe5"
  end

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "rbenv-binstubs.bash", shell_output("rbenv hooks exec")
  end
end