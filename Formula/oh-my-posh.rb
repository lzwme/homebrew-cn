class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v16.9.0.tar.gz"
  sha256 "bef27ca295ad46a8ccf64b22cfbc1291fe0ff5ae088fd7163f22d0c20be04da9"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d67b18eb1b22e28d83663baf19111ff30c5e455382dbb14e4678a69a371a90dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "436b10aae9f2678479eef6e69de716bc6df4aa32dabda6ce391597aa0b5bd617"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78b0fd25ffdbbd59e3b56976ac44c9550ae100dcf18b492b9b70b23eb9243b92"
    sha256 cellar: :any_skip_relocation, ventura:        "e0cd752f3ca1aea65f7d827161168fd54444ee6ca4c2d655045fadecd33b2f29"
    sha256 cellar: :any_skip_relocation, monterey:       "b34ad674ed8e64d302ce1b406888e5d6d4a5baa631ceb1c5247e2b135f04107d"
    sha256 cellar: :any_skip_relocation, big_sur:        "617ba2a6ab11d9dc841f27e574d50ac6d598fd7e4177889a5c5d2fef7e92f4db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a51c6bcfe14e65af57b3bd9d1af369158a5cfbafb45f9db1cfab6f9be509f6fd"
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