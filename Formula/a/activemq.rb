class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/6.2.2/apache-activemq-6.2.2-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/6.2.2/apache-activemq-6.2.2-bin.tar.gz"
  sha256 "47cd22a66d5ddd16c9613b47f1bb3eb1caa5ab7da7961aedc827583014837c92"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "019d49ae97c463e5353005d75cfe45dde97d4f5cf79b76d4c01274f23464440d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cae7a50d4aff734ae672bbc7e01abd83d9b76bd9ba6b2afaa4b5aeb1ee39ae5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c598a331bac37b62063b1dbeb2ebe70db7ae84f84678cd4afc4bda20df77b491"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a7055c0ab3b562c74658b76b845fa6b30545902130316fc86df5f5f8711dd63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9300825c13a5038d3dda7fb678d6e615f4905c93f78df8393b90f6bdcf75585"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "740ef6bb67c43d4e7e89a286412b0aeee561a7cf775aac5b48d857fb88617a59"
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