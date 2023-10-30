class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.17.0.tar.gz"
  sha256 "128b6f816c31016a61bb409030b355282c1aa61f9c0d3455d41caa7551225f94"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f39674fd87cd987dafc2c9ad1935fdad5a03526e365fc12cb059a54c343bc74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb2353b5efdac2a2a2ba25d62d56e3e4de8ca47beb389cd147ba18b4da98b74f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1d06ad29f555e193aa8e64334f1ee77500efd5214a166e28356f835c543ce86"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc92e10a38569113889364f63c54bb7899962f781d4aba33fe5321d47a79122a"
    sha256 cellar: :any_skip_relocation, ventura:        "ca06557b99d52a639da8f5985ce37ef5bdcfa0eacaca15df471a76780eddf0f0"
    sha256 cellar: :any_skip_relocation, monterey:       "fa843f177be5a4857e8484155f38f64ae1544e937b8cc07eb5effa0bb6bb737e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a58fed89f5a3ce24c77f8094c8576af9ac88afd812f0696ade43eb7379d5b67"
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