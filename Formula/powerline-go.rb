class PowerlineGo < Formula
  desc "Beautiful and useful low-latency prompt for your shell"
  homepage "https://github.com/justjanne/powerline-go"
  url "https://ghproxy.com/https://github.com/justjanne/powerline-go/archive/v1.23.tar.gz"
  sha256 "56c1e8818eb2695ed9bad94feab388f041cf857f5f8073aaa950c1a6925c5b54"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b10dab12e06f72d2d97aae4bba7586623f8dc3f911b02a7741f7ed335446a4d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7de71985597d3efc824e77c23c7252f93e24306d7c26e1e76c5a23b6d892b192"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ccd067b48691d274ceeb01b219f4d3407e1fc930ba685d24aad8a205121516cf"
    sha256 cellar: :any_skip_relocation, ventura:        "6e57a6a7363aa96092e6dba0ecce6dd0e9a3cdfb4cd42a16e3f1083941fcc548"
    sha256 cellar: :any_skip_relocation, monterey:       "dddc5d27df55fa3f968b280042638995918948031d111d6715f4f1258bdd832c"
    sha256 cellar: :any_skip_relocation, big_sur:        "42becb974142b9702013e2d70efc117807c2341665ecf06d8b4782f26cb69260"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e20c60fe493eca666107c3a0f86d3c8c47d75969d2e80d88dd68ad03cf12b754"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/#{name}"
  end
end