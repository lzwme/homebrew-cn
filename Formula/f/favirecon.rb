class Favirecon < Formula
  desc "Uses favicon.ico to improve the target recon phase"
  homepage "https://github.com/edoardottt/favirecon"
  url "https://ghproxy.com/https://github.com/edoardottt/favirecon/archive/refs/tags/v0.0.5.tar.gz"
  sha256 "d1e6d06cc005770475812118c98fc8602faa47609ef584a718364f0363b97100"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13e4bb9a851f6ea50a640cdbb3047a315f927122076d5c66c3746d4aabeda4ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb2106aebec65ae405bccb261a4c6a3fc331d762b006e7d7747b659763c2bb95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d6fc4f65eaea4908b780fe001f5721b6db54cf7e8e453de167c5f82f4784118"
    sha256 cellar: :any_skip_relocation, sonoma:         "46db8242b7bd368ad7a4fb2bd34478147ce549228e01766d572898079646fc5e"
    sha256 cellar: :any_skip_relocation, ventura:        "7a818c39db73baba0c31098cfeb58e6ea2fc3e7f1fe71cbdff7a0b933370abc1"
    sha256 cellar: :any_skip_relocation, monterey:       "e0098b8058e08a2186847564d80025d595e9f0d1ca7c435919c42b362d30bb3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0542d3a8b7d53e62d8b6eb004747bb2dcd0871edc165b9e1fbc87e622e298ca5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/favirecon"
  end

  test do
    output = shell_output("#{bin}/favirecon -u https://www.github.com")
    assert_match "[GitHub] https://www.github.com/favicon.ico", output
  end
end