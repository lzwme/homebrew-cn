class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/5.18.0/apache-activemq-5.18.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/5.18.0/apache-activemq-5.18.0-bin.tar.gz"
  sha256 "d96b380d68d1f0575b93d25e7a8913edb69c1d459f205af9e6f94328c2f17690"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09d8630a86b7e8c5c6418a004989507a60a279a63ffd596607a7139ccd8e2ea2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5986802e25e204a3c2342ac3b49149b4f42529f156667d304a81742ad2db8608"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "923f9f4c266b294960339171dafbd0c734c7e88bfcd9d37fdb4f5cbdfbc9b9ed"
    sha256 cellar: :any_skip_relocation, ventura:        "83434ad2dba48f8d187bd190f2df778947d5fd9ac15ea75e2195fb8ab7352faa"
    sha256 cellar: :any_skip_relocation, monterey:       "37cc16f56e5e9fcaaddec04e03cc626cd1ac07842e6f40a8b8d7ae62c3b43157"
    sha256 cellar: :any_skip_relocation, big_sur:        "c64157250b77c96113a5ffabc86413a986d2f27f1f8b4ac098cc29150fac02a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc746aa74c407063dbfadf46fb962f4a0b2f207b25dc3549ef562f0bf8bab5f0"
  end

  depends_on "java-service-wrapper"
  depends_on "openjdk"

  def install
    useless = OS.mac? ? "linux" : "{macosx,linux-x86-32}"
    buildpath.glob("bin/#{useless}*").map(&:rmtree)

    libexec.install buildpath.children
    wrapper_dir = OS.mac? ? "macosx" : "#{OS.kernel_name.downcase}-#{Hardware::CPU.arch}".tr("_", "-")
    libexec.glob("bin/#{wrapper_dir}/{wrapper,libwrapper.{so,jnilib}}").map(&:unlink)
    (bin/"activemq").write_env_script libexec/"bin/activemq", Language::Java.overridable_java_home_env

    wrapper = Formula["java-service-wrapper"].opt_libexec
    wrapper_dir = libexec/"bin"/wrapper_dir
    ln_sf wrapper/"bin/wrapper", wrapper_dir/"wrapper"
    libext = OS.mac? ? "jnilib" : "so"
    ln_sf wrapper/"lib/libwrapper.#{libext}", wrapper_dir/"libwrapper.#{libext}"
    ln_sf wrapper/"lib/wrapper.jar", wrapper_dir/"wrapper.jar"
  end

  service do
    run [opt_bin/"activemq", "console"]
    working_dir opt_libexec
  end

  test do
    system "#{bin}/activemq", "browse", "-h"
  end
end