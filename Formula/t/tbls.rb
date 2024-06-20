class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https:github.comk1LoWtbls"
  url "https:github.comk1LoWtblsarchiverefstagsv1.76.1.tar.gz"
  sha256 "89ace17b2052a78543e15eeab5b666a0b311487ed8de3a499d8532b03c3a30aa"
  license "MIT"
  head "https:github.comk1LoWtbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0ff75224e7becbaa16d38c6482f95287e0533aa04c64dc1fd5ce9d5f11c54fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4421a6b340f953f650dfe2cce659bc8ad55355c15aacf9f3acba9e9c27b3ad8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a99632669ee483aa5b710c5ef46b7f37bb24a7493898c76f45b09f5ecc233dbd"
    sha256 cellar: :any_skip_relocation, sonoma:         "acaf9006c9cbc103829ce17bc7bd5ab24ac396a8274156407ff3284e51ff86d3"
    sha256 cellar: :any_skip_relocation, ventura:        "0fe7690a331c2e8171c520bc957a784150b43aa742b9a22eb143c3184059ac9a"
    sha256 cellar: :any_skip_relocation, monterey:       "53b10cf7b84a873ffe7380c95ab6a2252af62205eade32ab0f128462d60181a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d06c2e1f6594abed14ebba92c8f001677390acfbeb7a8c1193b6c78e7763095e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comk1LoWtbls.version=#{version}
      -X github.comk1LoWtbls.date=#{time.iso8601}
      -X github.comk1LoWtblsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"tbls", "completion")
  end

  test do
    assert_match "invalid database scheme", shell_output(bin"tbls doc", 1)
    assert_match version.to_s, shell_output(bin"tbls version")
  end
end