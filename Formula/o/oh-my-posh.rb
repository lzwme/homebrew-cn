class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv23.6.0.tar.gz"
  sha256 "7c7ff26499101e01067ddc40a5be545b696f5d481f36c5e0c35c43aebd47cb71"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43599dba9c0ff3a8dbd1c9c2ab1e05523515aebc19a4d4ab1e42c464d37bc7c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93e4ca36cdb962f9cfc94d6479a7ed3ed024489abd0bfe26028505c8d1d14999"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc1d2eae012e1c8f0fbbc20048c1853f8cd203f5ea9a1b04d4a9d26aaf73836b"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2118855470f8966fd026525d91d951212bfdfa75eb73d3dd7c2372053b04784"
    sha256 cellar: :any_skip_relocation, ventura:        "55813e503f1562e237eb9235a1283a07b745d497a58a29ae1b062aaf637bdea3"
    sha256 cellar: :any_skip_relocation, monterey:       "f480246f166f08da50e6941d7971375a14f2723259a5209743e7e8bb1c3c9efd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3324ab7d5c6fcb97edbdf33ef2b0542195adf7368140632bd12ca53bb95cfc4"
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