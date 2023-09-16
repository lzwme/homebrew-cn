class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.9.1.tar.gz"
  sha256 "4854f7f6bc9f5cfd2f52da867585499ab5f33e0816411310dde86ae35ba2316d"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2679c6183fa49c078ffc9a680ceca07a555fa036790f1e03cb1a588b9701edd6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8cb9f578eb84a0e073f5761e70df27e112385d2d01ba99bb1957203f326a874"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f34f38d74fe2c006348a2fd624546c124cda1ee033de8b9c263c3d79d75d5fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbaea9b1365b69afc6c138b4518fc8c80ddb4c2cb61548db7e63c847e71d72ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "4364bf52057bfe38bfe2e5590cb53aaaa641b9caa6ab067334c9d3c665048bd0"
    sha256 cellar: :any_skip_relocation, ventura:        "548a0bfe24c83856a0d8fadef49453289cbee35c1786200bf07cd41410727284"
    sha256 cellar: :any_skip_relocation, monterey:       "dba1030b392f70f442e9e3c9533010b03a54df357dd7745e539c1d5d746fb924"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab14c628a7d1085f1724a1960b116a5a345c5821266657537b30222eda6853e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c896386e51b93d027425e28dee919455156e87aa92fdc9efba2082ab20046620"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end