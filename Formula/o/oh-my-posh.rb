class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv23.12.0.tar.gz"
  sha256 "485f10b4942f0c356c1f94085b4756215ba6ccdbcbd7f96d5ff7e8f9a9b9150e"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55ffc705046e8b63cec4e5b56dd03f36128d67b2f61a6e5c53b682dac4326757"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f99b74a009725dec318dee6e68274ccf6f9fefe51c19935e358ceabba7f2d30a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc9e1e4cd32d5bd317e8f8e3b3f79c2cb96eb969c44c0d7e2801dacf3b2637d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "3818ad2e7b95baffb0f94fc03f4a6dfcff8ea2530d41e5da4054db47020df2a5"
    sha256 cellar: :any_skip_relocation, ventura:        "a69ef17c9de3c7e8bd298639a9518f3c2e6e4b246764fe6c9ad9f8edbd8f6f12"
    sha256 cellar: :any_skip_relocation, monterey:       "687db5b4bf730a90c91cb3222bedc2341780ff5ee72af61bed760c7b7dd45891"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f33b530423f7119522c64a97f2921770a98ff069a8f0b617567d90415e633bb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Version=#{version}
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh --version")
  end
end