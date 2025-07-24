class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-4.0.28.zip"
  sha256 "953a485fd45bfb7e513bd45db8d70eafe61930e8cf374028dabbf37266807cd2"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.apache.org/download.html"
    regex(/href=.*?apache-groovy-sdk[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00ad19715cade97fb2c26569bd2159d4606ba1233ab04038a33230c1f12de9ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00ad19715cade97fb2c26569bd2159d4606ba1233ab04038a33230c1f12de9ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00ad19715cade97fb2c26569bd2159d4606ba1233ab04038a33230c1f12de9ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "c70103d4742920d045d29e9a4920f04379d53ab8809b0f9d40c0790387b8bc54"
    sha256 cellar: :any_skip_relocation, ventura:       "c70103d4742920d045d29e9a4920f04379d53ab8809b0f9d40c0790387b8bc54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00ad19715cade97fb2c26569bd2159d4606ba1233ab04038a33230c1f12de9ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00ad19715cade97fb2c26569bd2159d4606ba1233ab04038a33230c1f12de9ec"
  end

  depends_on "openjdk"

  conflicts_with "groovy", because: "both install the same binaries"

  def install
    # We don't need Windows' files.
    rm(Dir["bin/*.bat"])

    bin.install Dir["bin/*"]
    libexec.install "conf", "lib", "src", "doc"
    bin.env_script_all_files libexec/"bin",
                             GROOVY_HOME: libexec,
                             JAVA_HOME:   "${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
  end

  test do
    system bin/"grape", "install", "org.activiti", "activiti-engine", "5.16.4"
  end
end