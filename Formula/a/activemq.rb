class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/6.1.8/apache-activemq-6.1.8-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/6.1.8/apache-activemq-6.1.8-bin.tar.gz"
  sha256 "042add311ebdf3102c97ef2763c0e9c1d6591fa2c7d82e4504d676b11526b419"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2cdb9cb997ff21a907fd48f2509dbf276e2bee0df3ec6ef3a0c96ba2a7b979c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c98092e16d799a4147b904bea384ebd42fafd2d41eaa0d7571e37bef7ce45a95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66c3baa2e66cf134485ac695a4a15ab849728e9dfe556b50b13a7389f10ab651"
    sha256 cellar: :any_skip_relocation, sonoma:        "96aac16da73d71e43539ebaa6c9712a4b088f4fac5b9d315eb2a5fb9765c972b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "422d67dbd7a055b70b4029989418f407bf0adbce611531fc7906ede1c111bcba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0726f734a41230c8ce201e0ed155e93705864acb5f5c2f101b0e786f5e5efe1"
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