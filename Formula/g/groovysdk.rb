class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-4.0.16.zip"
  sha256 "09e705f7d7ba175e0e0d39b7aa121685958cf9e7bd7da37a8a7cf97f98de70c2"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.apache.org/download.html"
    regex(/href=.*?apache-groovy-sdk[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd44eba34882274640b18d06fe9a83919be33d457ccf3a7eb2c8ffb0b8ba52c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd44eba34882274640b18d06fe9a83919be33d457ccf3a7eb2c8ffb0b8ba52c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd44eba34882274640b18d06fe9a83919be33d457ccf3a7eb2c8ffb0b8ba52c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "665ec951cf5f78fbc347ebe36f57285cb3a93dd0722d9177a796bb5e520dec32"
    sha256 cellar: :any_skip_relocation, ventura:        "665ec951cf5f78fbc347ebe36f57285cb3a93dd0722d9177a796bb5e520dec32"
    sha256 cellar: :any_skip_relocation, monterey:       "665ec951cf5f78fbc347ebe36f57285cb3a93dd0722d9177a796bb5e520dec32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd44eba34882274640b18d06fe9a83919be33d457ccf3a7eb2c8ffb0b8ba52c0"
  end

  depends_on "openjdk"

  conflicts_with "groovy", because: "both install the same binaries"

  def install
    # We don't need Windows' files.
    rm_f Dir["bin/*.bat"]

    prefix.install_metafiles
    bin.install Dir["bin/*"]
    libexec.install "conf", "lib", "src", "doc"
    bin.env_script_all_files libexec/"bin",
                             GROOVY_HOME: libexec,
                             JAVA_HOME:   "${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
  end

  test do
    system "#{bin}/grape", "install", "org.activiti", "activiti-engine", "5.16.4"
  end
end