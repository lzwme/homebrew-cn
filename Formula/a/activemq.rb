class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/5.18.3/apache-activemq-5.18.3-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/5.18.3/apache-activemq-5.18.3-bin.tar.gz"
  sha256 "943381aa6d340707de6c42eadbf7b41b7fdf93df604156d972d50c4da783544f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f34b87f98e7cf3e5a1e75a63ecdef81df760e092be5a000e66c7a8dcf6ad537d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65445c6c929113a70b05d9a7717c00773b331eff2215622554833a10bf1a132f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0e386c44fa4e9e69b42fbcfce3855085335b8ac671e89fac3f93fca3884fdf7"
    sha256 cellar: :any_skip_relocation, sonoma:         "01afc373450d724882f22d0267366a9b835124a30c43bc94c51c2b37640f1de5"
    sha256 cellar: :any_skip_relocation, ventura:        "1a3c98f09111d0944058aaef8908b82c42542bd8e14b27b0ac47ac267d72e054"
    sha256 cellar: :any_skip_relocation, monterey:       "19a8a810c0e04f50635a9350e5d28dfb42c6eed3ee7cf4a478c00b89f31e797e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebc32cc17d36085d60ccc6aff3e6f3f72f6ad00af3d6440fa36a2b7febf88835"
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