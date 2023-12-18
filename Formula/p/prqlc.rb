class Prqlc < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https:prql-lang.org"
  url "https:github.comPRQLprqlarchiverefstags0.10.1.tar.gz"
  sha256 "401c6e9f22ea8877e0779b5158759434e4f0781be6085c8748aa8ca394622eb9"
  license "Apache-2.0"
  head "https:github.comprqlprql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6bdadd1cf478a032936462c7b503b56ad8f7b6306d91bedc0a05b92c06f4299"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "097863b5a6734741a70f19782c3d7e12ecdaa2f0835337f99f17f24f6af7b439"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad41cae9c3500d7b18f5e41a62e3bff3c7b6476be9728f377327874156a93d7b"
    sha256 cellar: :any_skip_relocation, sonoma:         "49be71d7b188e9f1d1ced6e709cb76b6ded1a0c049d831fb9847343551df769d"
    sha256 cellar: :any_skip_relocation, ventura:        "71d980290d1052d9c6bcf02fc621ae9de3e1fd54dfc4e0186cab76131b98f9f7"
    sha256 cellar: :any_skip_relocation, monterey:       "a45ac335a71478f607b1ca9171d0f54c058dff2708d2bcd383a3d76a0fb28d56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21a741ecf6e0508d13535e14311c8d31e35303fcd7868f9461407bafd0be4176"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "prqlcprqlc")
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end