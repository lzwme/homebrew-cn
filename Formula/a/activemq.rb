class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/6.1.4/apache-activemq-6.1.4-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/6.1.4/apache-activemq-6.1.4-bin.tar.gz"
  sha256 "f1bd27a345d434ec3753650b5ad356f51ec30165ed01a8ef8749c6b9391535f3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a33223433cbc182b8e0f69681c5c8783a286caf14ba14d54a6c6af359b6194f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "024cbdd4a38849bdbf26d4cf9bd741a0f8d2899c55d6dba32552f8ddfa6c9ba8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f97b821b25920a572a38fbd553788fa1ebdbfa99b450d8111af2e0c1092f2b8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "518159896f2fd33539f07fbddf795353c080c8623a6ebe9d655dd5b26e7618b9"
    sha256 cellar: :any_skip_relocation, ventura:       "8e3b7f4f41ffe894e41dd5f7fdc74c98725ec56356388b69d6a79b860a01fcaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f55d581b78a0ea1baa0329eba94da3c83261009489d220e7621fb027c1f89c5"
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
    system bin/"activemq", "browse", "-h"
  end
end