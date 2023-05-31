class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://ghproxy.com/https://github.com/projectdiscovery/subfinder/archive/v2.5.9.tar.gz"
  sha256 "1896aa51b20a04c4abb837671632206355733954138fa3f1d9b039a355cf73a8"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b55349f9b49b88631d3f4f3a56b2c05462de482107246e93c892712890747636"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b55349f9b49b88631d3f4f3a56b2c05462de482107246e93c892712890747636"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b55349f9b49b88631d3f4f3a56b2c05462de482107246e93c892712890747636"
    sha256 cellar: :any_skip_relocation, ventura:        "2d4618478a439593856480296cae6a126c32c889436d3baca7172ca9d367ba3e"
    sha256 cellar: :any_skip_relocation, monterey:       "2d4618478a439593856480296cae6a126c32c889436d3baca7172ca9d367ba3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d4618478a439593856480296cae6a126c32c889436d3baca7172ca9d367ba3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb4e86cfdc04fd354c9c1bf056aa88df8285650cc62ace1281c5550e3cc8460a"
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