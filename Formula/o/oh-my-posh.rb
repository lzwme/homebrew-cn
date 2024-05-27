class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv20.2.1.tar.gz"
  sha256 "03dfd2143a22e9a88d793d93ba37a623a94ed861673199c9d07dab75740b0201"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "250b6aaf5da1b1d69ad4cf5422fc49e89b7a57651efad0fb4d7c83daec66d576"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f820d1619b6f550fe6974b3a15297b9ee4276807d0077a51c5a2abef54ba1456"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93a5b1302c6437cc5032e75c641e845ce31a928907b7d68fd8a0fdcafc83fd66"
    sha256 cellar: :any_skip_relocation, sonoma:         "07193d5b5aa88c12f31cfa4320f591762b953c536cf32db74a3a6527367d0ad5"
    sha256 cellar: :any_skip_relocation, ventura:        "54654796dce969d5b64e36493971fc2ec0c7fc04b8ddca3531c3e47623921ed2"
    sha256 cellar: :any_skip_relocation, monterey:       "4264289c41b08ed99c6f847f070009a6f25f0a511373d6c21a742e03d67da61d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a13c658b81619c990a54db517bb4e7273284075f1b2d4064f1226e7ca24b67f"
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