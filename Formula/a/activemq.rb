class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/6.1.1/apache-activemq-6.1.1-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/6.1.1/apache-activemq-6.1.1-bin.tar.gz"
  sha256 "2035ed4ec77078f0e604e9430615e3a4bc9474d53b2c69e4893aee00ac53e1ab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8af2fad9ccaaa9b8415c97ce9be22da7240ad486cb4ec3d9f4e69fccf875b730"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f800916affac8fd4161a93627b8e4cbe0692ef6db257c08e5487c4c778779a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77f00c71c3731f066c42e6838bd7c65c6e26b20745b8ec3dbdb79d7a74f5cb7c"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2cbafac061b598fda37a43d940daabf8c977f0bfb5b4c8150b0cea99e5a6af6"
    sha256 cellar: :any_skip_relocation, ventura:        "7d271f31c69bb73e4759c6a4dc48ecd230668c20711a4dd46664fd80eed28848"
    sha256 cellar: :any_skip_relocation, monterey:       "01463e19bbef0c8778b059255c7af47881f78ad30f40abfaaeec5ac3b9411089"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07a183a9223e8a41bec8e2417a986ba78b01521aa7ea3f7fe045794a519fa7ef"
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