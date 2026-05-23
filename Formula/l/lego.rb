class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://ghfast.top/https://github.com/go-acme/lego/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "3cd4871658fbf6460655a66bcff7c193481b56bc91cd8902000592585597c8ef"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2251619cbb43a280360d72d62368e79994758247dd435def8bde688879cbcbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2251619cbb43a280360d72d62368e79994758247dd435def8bde688879cbcbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2251619cbb43a280360d72d62368e79994758247dd435def8bde688879cbcbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "29da0cd5ed44ea1d141d604be3a875897509ffef5f0706b9fe811ac7afe01849"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a1990207cf20b0c0d236d529133c656c4333b12d8ad17126de7665829f08f73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d28edb0a847c5aee676eaa85bcf34a072aafca5ad39e663ce85e13165d6f613e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    output = shell_output("#{bin}/lego run -a --email test@brew.sh --dns digitalocean -d brew.test 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output(
      "DO_AUTH_TOKEN=xx #{bin}/lego run -a --email test@brew.sh --dns digitalocean -d brew.test 2>&1", 1
    )
    assert_match "No account exists with the provided key", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end