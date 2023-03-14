class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.13.1.tar.gz"
  sha256 "c4f822c6f58e617517d475a237f4b178a907a17b1862eaca548192d2d64c3426"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2797180301254b0d70d2d42cf43fc08c994511008b540052fa9c8f0887d7c6d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf7647ccc45a20fd99ba2fae233040c1b755f120fa25e566ddb1657fe4c7a5b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8fa94d3b955956fdee9d6ad5b9a0c66aa9fe86253688736077c93680fd100b4"
    sha256 cellar: :any_skip_relocation, ventura:        "869622c1e9902c673e360dba77a216067452c02c7075b81c00afb64557232cf9"
    sha256 cellar: :any_skip_relocation, monterey:       "aa77d61ae1e4a3490ba55ab1e1a2035b9d13af94fbe961f45ab0441083de7c4a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a0a4a974694a4866ec78b7911b0866eea458b525c31070229d93aa1ef48b78c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efd6b936e0ff95a57a1e56052534382a7b1aecd247c8802c1eb4e1585e53ec0f"
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