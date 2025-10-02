class Nom < Formula
  desc "RSS reader for the terminal"
  homepage "https://github.com/guyfedwards/nom"
  url "https://ghfast.top/https://github.com/guyfedwards/nom/archive/refs/tags/v2.16.1.tar.gz"
  sha256 "c61f49670e1e970355f0b05f30d0703bc32416bd83b3ae19bcec3810ccda05ac"
  license "GPL-3.0-only"
  head "https://github.com/guyfedwards/nom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17e922cfb414fa68a79b78c6ab659a967125794beaffbc19540d3c8498ba09c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0360c2b648b54eb2059da6a599fd0b440588c86045f526c23ee663bb2f06123"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62679716b03ee339d4299b682394e0a212d210342c35d9fcc232fd5103477c35"
    sha256 cellar: :any_skip_relocation, sonoma:        "f65d1660079bdbeb6b206571b1190ba905f8d1fdf1de90b2b361d691f6e7ba20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "133270331a4c055d4e885269ee2c09dfb8591dfe7c1c96a9a3e6df419b1f65ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa3962e953f2f62e1b1c105540b773264ea5b4215b2e82015747703e685dd569"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/nom"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nom version")

    assert_match "configpath", shell_output("#{bin}/nom config")
  end
end