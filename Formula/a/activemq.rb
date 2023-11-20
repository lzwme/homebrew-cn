class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/6.0.0/apache-activemq-6.0.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/6.0.0/apache-activemq-6.0.0-bin.tar.gz"
  sha256 "02274164aacb1883ed997ae060aed8116c57cac3153e2a1d36aca218cc907146"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "615018d1f2c4b761a8794f7d7e6bba9cf1d51ec85b2993058e03fc4cacb710de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2a1b50d4fd6098a938222b0b205550666a7979a73e67e6bcf8d0f97c9252138"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34c9f1500841a037d89f5aec35c0bd22c53cf0ed7aec9d1ac357c5e8f38da837"
    sha256 cellar: :any_skip_relocation, sonoma:         "ffe5c38e651aa4708b35c48d288f2806177ac18da9cbfceb854513cceba46824"
    sha256 cellar: :any_skip_relocation, ventura:        "0c67ca299fee20f9634fd462054a58bd83541afcfc5963e1371edfb29abeb2a5"
    sha256 cellar: :any_skip_relocation, monterey:       "36e49150a536e321e7411ce37b8bc6b80d0cba87569e1143cafe27e255e77934"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62c7c3d000389218f4d16818aface8665f538527ed2a26eb7f8d9da9a7e756b4"
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