class Doggo < Formula
  desc "Command-line DNS Client for Humans"
  homepage "https://doggo.mrkaran.dev/"
  url "https://ghproxy.com/https://github.com/mr-karan/doggo/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "1965f4c909991bc38b65784ccbc03f4760214bca34f1bb984999f1fc8714ff96"
  license "GPL-3.0-or-later"
  head "https://github.com/mr-karan/doggo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fceb196ab22d9a9f9172f2f9fccfcd84ae6022ceb8b3b65ad794aa58e7485cd7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fceb196ab22d9a9f9172f2f9fccfcd84ae6022ceb8b3b65ad794aa58e7485cd7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fceb196ab22d9a9f9172f2f9fccfcd84ae6022ceb8b3b65ad794aa58e7485cd7"
    sha256 cellar: :any_skip_relocation, ventura:        "a548503cd8dd80fba7103fce86e2a429d24f50df2fa75d92e2323380f8071fb9"
    sha256 cellar: :any_skip_relocation, monterey:       "a548503cd8dd80fba7103fce86e2a429d24f50df2fa75d92e2323380f8071fb9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a548503cd8dd80fba7103fce86e2a429d24f50df2fa75d92e2323380f8071fb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "778ab912f7339cb843103c0aed18fc38b506bc44298552d9c69651032eb919a1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.buildVersion=#{version}
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/doggo"

    zsh_completion.install "completions/doggo.zsh" => "_doggo"
    fish_completion.install "completions/doggo.fish"
  end

  test do
    answer = shell_output("#{bin}/doggo --short example.com NS @1.1.1.1")
    assert_equal "a.iana-servers.net.\nb.iana-servers.net.\n", answer

    assert_match version.to_s, shell_output("#{bin}/doggo --version")
  end
end