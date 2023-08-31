class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v18.6.0.tar.gz"
  sha256 "b7042f70e7384aea62765e5bc1926a9c7c215f4f6225cc1ce710ae6773eab4c7"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4105481bbd10e8b9b6cc8bba4e796a014e376d4dcabf705bade4d4f6d6fc8f58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97d57fa1a3349c25e27d78ee38ac31004e4b0365022e3ae9c77b5be7dfdbd213"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "559251c94122ab8a28a449540d243a04775e377dae657c8d02047a2f03fb8140"
    sha256 cellar: :any_skip_relocation, ventura:        "0bc130b2d980faccb1ab7975bcd9d4102210f98e32819f34fd837c55a22f060c"
    sha256 cellar: :any_skip_relocation, monterey:       "a61be331183f3cde9236b445ff0157b2d2d625f4e584a8c7a3e5080e651e91b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6c9088e7e49aeac1eaa057a09447eac430fc178f3d2aa983be0481a89eb761f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "416f590d2b3939dc883d262b51c7e145041e56a3ff56ccc4624363594fcb9d35"
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