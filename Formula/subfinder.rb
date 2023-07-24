class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://ghproxy.com/https://github.com/projectdiscovery/subfinder/archive/v2.6.1.tar.gz"
  sha256 "18a297b283f3ccc510a1bf37000827c9b3d34738619133685092da2bc8bcc6dd"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2af70bb3f751738fd886489a36d254e5dda2c15823e68c74240a679400552324"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2af70bb3f751738fd886489a36d254e5dda2c15823e68c74240a679400552324"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2af70bb3f751738fd886489a36d254e5dda2c15823e68c74240a679400552324"
    sha256 cellar: :any_skip_relocation, ventura:        "65417c22a7ef7d06e60394354e4489c9079cfa57f8acbf69a722562d2ddbf34b"
    sha256 cellar: :any_skip_relocation, monterey:       "65417c22a7ef7d06e60394354e4489c9079cfa57f8acbf69a722562d2ddbf34b"
    sha256 cellar: :any_skip_relocation, big_sur:        "65417c22a7ef7d06e60394354e4489c9079cfa57f8acbf69a722562d2ddbf34b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10f1731e7f57a134105242bb7f2e854fda167433cc6df73e7effa63789888d48"
  end

  depends_on "go" => :build

  def install
    cd "v2" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/subfinder"
    end
  end

  test do
    assert_match "docs.brew.sh", shell_output("#{bin}/subfinder -d brew.sh")
    assert_predicate testpath/".config/subfinder/config.yaml", :exist?
  end
end