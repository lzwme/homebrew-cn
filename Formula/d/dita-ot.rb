class DitaOt < Formula
  desc "DITA Open Toolkit is an implementation of the OASIS DITA specification"
  homepage "https:www.dita-ot.org"
  url "https:github.comdita-otdita-otreleasesdownload4.3.2dita-ot-4.3.2.zip"
  sha256 "e4cf98321289ee0edbf819b441d1fa5e155099dcfc02132f2e130700e07114b3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7f739da85ad61e2851d2cf15ab1896d901158e024ac7a117b5f1abbe9669b72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7f739da85ad61e2851d2cf15ab1896d901158e024ac7a117b5f1abbe9669b72"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7f739da85ad61e2851d2cf15ab1896d901158e024ac7a117b5f1abbe9669b72"
    sha256 cellar: :any_skip_relocation, sonoma:        "5188796cddaf20adf640b8d238814e62daa08ac10a1f2bb07ea6570a3a2bdaa6"
    sha256 cellar: :any_skip_relocation, ventura:       "5188796cddaf20adf640b8d238814e62daa08ac10a1f2bb07ea6570a3a2bdaa6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62292ce7f061c6f472eb259c39050f17da94be0b3d1da8bb9fa5e79c5b19c3ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62292ce7f061c6f472eb259c39050f17da94be0b3d1da8bb9fa5e79c5b19c3ae"
  end

  depends_on "openjdk"

  def install
    rm(Dir["bin*.bat", "configenv.bat", "startcmd.*"])
    libexec.install Dir["*"]
    (bin"dita").write_env_script libexec"bindita", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    system bin"dita", "--input=#{libexec}docsrcsite.ditamap",
           "--format=html5", "--output=#{testpath}out"
    assert_path_exists testpath"outindex.html"
  end
end