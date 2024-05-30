class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.0.0.tar.gz"
  sha256 "456311dfed1280257144b680525bd44828abae72e65da7c3ae61b603605f2804"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "719c128ac5040b27896da3f65c4748ea720813d4e02a48046ae48f1fdefae0b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b00fb7838f55af0721091d7ca2606c74c130c908dabd807aca7b365e56e9e562"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "feea2313774a956cec699039d213978c7a769c15a6de5c415f2794f9de122c44"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a421d92ff1d1bb260529f885fa2469699523da65c39f6692e966949c44b131b"
    sha256 cellar: :any_skip_relocation, ventura:        "a62d2f722cb63cfc1cdff6463027f25b6d079bee8265c1b899ac9beb52a9940f"
    sha256 cellar: :any_skip_relocation, monterey:       "7397ef754257d191c6bb8284303e54248cf8ef5adc1826cbf19e246712e188a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29d8e8366e6e1bfaf083bbb5e27ad709be296458028dda9cb45d35b405d8f040"
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