class Igv < Formula
  desc "Interactive Genomics Viewer"
  homepage "https://igv.org/doc/desktop/"
  url "https://data.broadinstitute.org/igv/projects/downloads/2.18/IGV_2.18.0.zip"
  sha256 "7b9a2c738e8ce7c15e5c7e85126eadc7e794cea78ebc0f5debfd611ab4ab6813"
  license "MIT"

  livecheck do
    url "https://igv.org/doc/desktop/DownloadPage/"
    regex(/href=.*?IGV[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "030f6d4754c2eb1adc896ec8f0642e2e83f3d1f8f1e777e9f70e523cdd0fd237"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "030f6d4754c2eb1adc896ec8f0642e2e83f3d1f8f1e777e9f70e523cdd0fd237"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "030f6d4754c2eb1adc896ec8f0642e2e83f3d1f8f1e777e9f70e523cdd0fd237"
    sha256 cellar: :any_skip_relocation, sonoma:         "030f6d4754c2eb1adc896ec8f0642e2e83f3d1f8f1e777e9f70e523cdd0fd237"
    sha256 cellar: :any_skip_relocation, ventura:        "030f6d4754c2eb1adc896ec8f0642e2e83f3d1f8f1e777e9f70e523cdd0fd237"
    sha256 cellar: :any_skip_relocation, monterey:       "030f6d4754c2eb1adc896ec8f0642e2e83f3d1f8f1e777e9f70e523cdd0fd237"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d701f4d22af3800ef187341b9b40dbc18baca38acf65cc624151917d3806927d"
  end

  depends_on "openjdk"

  def install
    inreplace ["igv.sh", "igvtools"], /^prefix=.*/, "prefix=#{libexec}"
    bin.install "igv.sh" => "igv"
    bin.install "igvtools"
    libexec.install "igv.args", "lib"
    bin.env_script_all_files libexec, Language::Java.overridable_java_home_env
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/igvtools")
    assert_match "org/broad/igv/ui/IGV.class", shell_output("#{Formula["openjdk"].bin}/jar tf #{libexec}/lib/igv.jar")

    ENV.append "_JAVA_OPTIONS", "-Duser.home=#{testpath}"
    (testpath/"script").write "exit"
    assert_match "Using system JDK.", shell_output("#{bin}/igv -b script")
  end
end