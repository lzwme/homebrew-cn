class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/6.2.3/apache-activemq-6.2.3-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/6.2.3/apache-activemq-6.2.3-bin.tar.gz"
  sha256 "750d42313c6852e95b1d11dbd994afec41ed4f6cbc021b9a55dbff7f1bf42878"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84332de537f92169b3e3d0f8a60940c7aa8b476cc199c4040c34b816fb0a8ce1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a60dd628c2c7ad0ed26fda9eb8a13a9b1fd5491cb85aeca1b8da6a3548f88f03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2caee31b53c4decb828c196b6f287fe1a6f14363c77f1661589a76876e5c150"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c98298aec5158973e2015047959810b8545f3d609c8d51907c0cbb9684d8c69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf2b51bc4fa630de2cf1cf21e5da10da77f80a0015f3b84ffb8a79962e38c055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9f2d233fd9097fe9aea3a5418f9fb8333a7e13ffb0615d860256224ac9bdc14"
  end

  depends_on "java-service-wrapper"
  depends_on "openjdk"

  def install
    if OS.mac?
      wrapper_dir = "macosx"
    else
      # https://github.com/apache/activemq/blob/main/assembly/src/release/bin/linux-x86-64/activemq#L176-L183
      arch = Hardware::CPU.intel? ? "x86" : Utils.safe_popen_read("uname", "-p").downcase.strip
      wrapper_dir = "#{OS.kernel_name.downcase}-#{arch}-#{Hardware::CPU.bits}"
      odie "Remove workaround for arm64 linux!" unless buildpath.glob("bin/linux-{arm,aarch}*").empty?
      mv "bin/linux-x86-64", "bin/#{wrapper_dir}" unless Hardware::CPU.intel?
    end

    useless = OS.mac? ? "linux" : "macosx"
    rm_r buildpath.glob("bin/#{useless}*")
    rm buildpath.glob("bin/#{wrapper_dir}/{wrapper,libwrapper.{so,jnilib}}")

    libexec.install buildpath.children
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