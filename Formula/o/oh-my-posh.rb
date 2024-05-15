class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv19.29.1.tar.gz"
  sha256 "b4dc939037d5b26a774b5a28e31e7bedb5e48c4418983c9c9de5949dfc83cdfd"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "56bafdb845ec0a2bacaac8885abbecfab9f10b50336dc3a68ee25745012ce3cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3561b3df58be5d60a83e749034884817532c8ac7dd9ea6e12e3e5ee799eb1e87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "507d4a79d291efcd1ab74f31ca9ebde2e17ca5a35ad9aa4164b6e8acb1140877"
    sha256 cellar: :any_skip_relocation, sonoma:         "bfcec83e1b240bdd73b26be7ddce74b89c55b574ea06ad406fbd2720edce7496"
    sha256 cellar: :any_skip_relocation, ventura:        "0f0202609393c8cf5a2676eb5d5bba32c5db19ad0331190126777258895cdca4"
    sha256 cellar: :any_skip_relocation, monterey:       "34413aa494569ef0c54ddb18550fb0ad504036291204911dfa4ba5b4eeff4154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e8300a5f77dfebd9ff82a34cae3cb88e49babf131eedc1aefed0379a00d1759"
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