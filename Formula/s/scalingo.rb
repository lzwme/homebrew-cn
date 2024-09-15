class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https:doc.scalingo.comcli"
  url "https:github.comScalingocliarchiverefstags1.33.0.tar.gz"
  sha256 "a449e9d8bb810360d626a2036c1f97baf10715eb112929da6a0089c4257cb835"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "345f9906ea56c2533abc5c627f8927b6c7a8f27449f36dc899d126be4cb70c27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7280bd13e407cd689ebda0789ecc0dcfc9567008c3c493c148b1ac63a796c2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7280bd13e407cd689ebda0789ecc0dcfc9567008c3c493c148b1ac63a796c2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7280bd13e407cd689ebda0789ecc0dcfc9567008c3c493c148b1ac63a796c2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1ee3f8bb17f64f68f0c7c611da5bf33469ba32e9eebe71c42f082d37f04d096"
    sha256 cellar: :any_skip_relocation, ventura:        "d1ee3f8bb17f64f68f0c7c611da5bf33469ba32e9eebe71c42f082d37f04d096"
    sha256 cellar: :any_skip_relocation, monterey:       "d1ee3f8bb17f64f68f0c7c611da5bf33469ba32e9eebe71c42f082d37f04d096"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2633bba3d45fc1823d35280af0bf74667cc6c09c77d09d9bdbcbff10519337f0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "scalingomain.go"

    bash_completion.install "cmdautocompletescriptsscalingo_complete.bash" => "scalingo"
    zsh_completion.install "cmdautocompletescriptsscalingo_complete.zsh" => "_scalingo"
  end

  test do
    expected = <<~END
      +-------------------+-------+
      | CONFIGURATION KEY | VALUE |
      +-------------------+-------+
      | region            |       |
      +-------------------+-------+
    END
    assert_equal expected, shell_output("#{bin}scalingo config")
  end
end