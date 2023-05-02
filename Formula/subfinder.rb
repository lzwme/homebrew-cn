class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://ghproxy.com/https://github.com/projectdiscovery/subfinder/archive/v2.5.8.tar.gz"
  sha256 "d1b8adfd674cc72127401d7a51dfef42f336bf5e0e1ac46815a2c48ee0129e69"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "684e6f58f80b9e1490b13fbf1e19a86f29bef3e5a79c2c28b34dc332c45a3fba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "684e6f58f80b9e1490b13fbf1e19a86f29bef3e5a79c2c28b34dc332c45a3fba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "684e6f58f80b9e1490b13fbf1e19a86f29bef3e5a79c2c28b34dc332c45a3fba"
    sha256 cellar: :any_skip_relocation, ventura:        "727d558d19e535896c69eab609d33fefafc4399485c8a483d6ecbf0681d9aed5"
    sha256 cellar: :any_skip_relocation, monterey:       "727d558d19e535896c69eab609d33fefafc4399485c8a483d6ecbf0681d9aed5"
    sha256 cellar: :any_skip_relocation, big_sur:        "727d558d19e535896c69eab609d33fefafc4399485c8a483d6ecbf0681d9aed5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dec0a5633a7db2c958a70068cd8fedfd643086855c42441445e5a8798ed0ddf0"
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