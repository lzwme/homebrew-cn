class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/6.3.0/apache-activemq-6.3.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/6.3.0/apache-activemq-6.3.0-bin.tar.gz"
  sha256 "853a786c304d456d4f7bc2ff8fda89d0ea7d755241048ed1ced9b51f5dabcc39"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18b7f21e842c0eb8b779dfe677e79ffd0b476b66a3fe3cc01fbebee059703db6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29295e3741fe9480e8096bbad4e5dc699a29c5759a482c8492bf9c72b138934f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5275c400936d07daf5171d68a61155f7e6902bdeb8d2dff026174aa8b9db88bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c2169e7120915d8ee231facbdcde7c86cc9d81c313efc4a9325e76bc564b328"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64e050a1b6267d0340646f455844ba68371704ab75b13de2b4989408ac71c4a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b16fc5237808b6ef84a5e9b0075e252abacc1e3f66837545293a3501852a314c"
  end

  depends_on "java-service-wrapper"
  depends_on "openjdk"

  deny_network_access!

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

    wrapper = formula_opt_libexec("java-service-wrapper")
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