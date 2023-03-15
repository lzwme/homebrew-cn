class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.14.1.tar.gz"
  sha256 "6dfe00dd4f5a6ca83d8fc47c17e590ffeeb742d39dfb13cca07f2a910fbed2be"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01b183bbdc2b85afc939e82b1b8f3d5f2cd5192c40e282b8621da4289fd9e61e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16399cca92d811f646c16aeeb1fc2263740bed303680b24367c6aeceacec2550"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b0de6ebb8dd92c3634a313ede4970eaf63e1db295f0bb7d6cb2128794cc8d90"
    sha256 cellar: :any_skip_relocation, ventura:        "58e070d77fd6de79763d50390d7bb90706e7b54d817935033b044104b99ccfc6"
    sha256 cellar: :any_skip_relocation, monterey:       "7f48c3b5a4bee364882cfe7edb9fca5ae1dac0694f1273bb7ce242968fe3ad9f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0173c282d1d8dd56b6726be7cd3393bd5afa751e3b7a890b8b711c30d8c22476"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3ba6ebcdc225298c6d31c902089b631169d5340c965f935360f2ebf7ce5d57b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end