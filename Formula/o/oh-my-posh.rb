class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.6.2.tar.gz"
  sha256 "fa3c3d4e5466a926d0ff9e304a462096161d244f222f34453f2a00c6b6a734ed"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13609932f247b3b8022db6cd01475d8599144a6aa09b3bf3bae73952e2be267c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddf7ca411f3d7fa4b808210dc6f1264f253ca4e3e266b97b37fabf3f9da7b8cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d9797f5048ddf1f272e1eef30bf94bb9fe92a59bb59b3cff0332ec53ca854c8"
    sha256 cellar: :any_skip_relocation, ventura:        "53bc6a63747184d8b02ee23efcdb829ecb64dd185b5d477655faec7957257029"
    sha256 cellar: :any_skip_relocation, monterey:       "3c58aa81a6f1fee0199245497672493e7969f686bab95594986fb5d3b3db686e"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f672077ce5e9ad21f9b8c6f8119e36d91a33d92bba87af534d82d422add1f7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f28f9a657f161141929d6716f360e0bb99f257e84407dc66bf1ad83a62aefa56"
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