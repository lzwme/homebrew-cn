class NagiosPlugins < Formula
  desc "Plugins for the nagios network monitoring system"
  homepage "https://www.nagios-plugins.org/"
  url "https://ghproxy.com/https://github.com/nagios-plugins/nagios-plugins/releases/download/release-2.4.7/nagios-plugins-2.4.7.tar.gz"
  sha256 "63833d03cd62ea5da85763c241c276c468e8b92730fd6f1701cc9828d73c7f69"
  license "GPL-3.0-or-later"
  head "https://github.com/nagios-plugins/nagios-plugins.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "048cc999792208bd20a910dbc338c838ae40f4e8ef892c4f4752c88cc388f6a1"
    sha256 cellar: :any, arm64_ventura:  "3f200d5b9539b9fc6a989043a47c72e4fe4cafdf59f7ac1fd9384439e035e146"
    sha256 cellar: :any, arm64_monterey: "e41fad39e1d516e54dede826a553d051f87066b4c58c72f5df72a7f0b0cec4e2"
    sha256 cellar: :any, sonoma:         "01705ef8d6e1cc6dfc91314d5c7faff83527e2a11f31370b7fb1c4d469877636"
    sha256 cellar: :any, ventura:        "270a1a08ca4a193c1a50ffd62e0423ff8210d48a40a1808e421e72324efaa585"
    sha256 cellar: :any, monterey:       "ad9e1ba84f2068b110247a0a51d3cc6f6583b84240e619a51db52c60bd1e4781"
    sha256               x86_64_linux:   "3ec8ef266de0948fdc7aaa8347241ca00bf89665215e1713237f2b543afac0a8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "bind"
  end

  conflicts_with "monitoring-plugins", because: "both install their plugins to the same folder"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{libexec}
      --libexecdir=#{libexec}/sbin
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
    ]

    system "./tools/setup" if build.head?
    system "./configure", *args
    system "make", "install"
    sbin.write_exec_script Dir["#{libexec}/sbin/*"]
  end

  def caveats
    <<~EOS
      All plugins have been installed in:
        #{HOMEBREW_PREFIX}/sbin
    EOS
  end

  test do
    output = shell_output("#{sbin}/check_dns -H brew.sh -s 8.8.8.8 -t 3")
    assert_match "DNS OK", output
  end
end