class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v18.3.2.tar.gz"
  sha256 "bb8a456e7b41497df1198f9d8f6a90e1ce44b4b7dc7bb68fc129bf0fbec639ee"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec64319bf01427d1287e078c1f373e03fd111c023f0cca0b47881026190cc472"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8d20f6791d342c7554c027c367ee202b77feb0c9c1177f90fc9d2e5d65ae2d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f497596d88dff4ae25a3f1aaf17a83e3440e60c485a11b18a966d082620ebaf6"
    sha256 cellar: :any_skip_relocation, ventura:        "b9f876a0c1297b8cb18938db2f34ff5c0987cc040cd259daad1b23f465109ccb"
    sha256 cellar: :any_skip_relocation, monterey:       "2b039db849735638ac7fad61a9022c82ecafcd80aa157f40416e7964b3b889f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "3cc52e9fcfa916d904ca70bdb9707ca0cf4a93ffd7b482514e6d97093dd2c1b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7387f00386429faab87676e9eda9c7df98e8f888973133c92c5c4f03797327aa"
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