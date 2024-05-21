class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https:huacnlee.github.ioautocorrect"
  url "https:github.comhuacnleeautocorrectarchiverefstagsv2.9.3.tar.gz"
  sha256 "d6567fafc2f93a5ba65e4e089524e6564832f889ef2b7b38acb06c140e2aaf1e"
  license "MIT"
  head "https:github.comhuacnleeautocorrect.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f04efa23efe1f2d8eaea3e188dde8cc6ca5eb1e00368928a797d43c998efb2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d2f74498570d956426d17dd79dab9fc5f3cc6de8d48ad5c8417be01956a0472"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e9b4748845c0b53a903dc94af33796eaeefb53323064fe9123e5d057eede3c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "3027d143dc4d743829e6eaeff0196b6bddf53754ae4e3a105b8da2a9feb11061"
    sha256 cellar: :any_skip_relocation, ventura:        "8a9d4408df95d09729a4a2dccc6a957461ce0062d7159c987548ea4c4275c676"
    sha256 cellar: :any_skip_relocation, monterey:       "4243dc0e20eefb6a52ba85d3e2ea05310f43db3fde14b69bf5885c047ff0d23d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3c0e452dfba311f87737af18558207e9d24b1d47ad1a14432db31bae0416acf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "autocorrect-cli")
  end

  test do
    (testpath"autocorrect.md").write "Hello世界"
    out = shell_output("#{bin}autocorrect autocorrect.md").chomp
    assert_equal "Hello 世界", out
  end
end