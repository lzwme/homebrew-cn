class Igv < Formula
  desc "Interactive Genomics Viewer"
  homepage "https://igv.org/doc/desktop/"
  url "https://data.broadinstitute.org/igv/projects/downloads/2.17/IGV_2.17.0.zip"
  sha256 "f8ba2668fdeaa8840682bca7776aa080912f306f74c698b1940632d35b7e7552"
  license "MIT"

  livecheck do
    url "https://igv.org/doc/desktop/DownloadPage/"
    regex(/href=.*?IGV[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "89db6def4171ca660d212e260a3a3c9ca59e2a46e26bc7d22e1b53a2110cd2fd"
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