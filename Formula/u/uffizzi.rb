class Uffizzi < Formula
  desc "Self-serve developer platforms in minutes, not months with k8s virtual clusters"
  homepage "https://uffizzi.com"
  url "https://ghproxy.com/https://github.com/UffizziCloud/uffizzi_cli/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "8437dd01ae74b4de562766700ab71cf0346bf354bbf32451d273ea90c954ad8c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7775093bbe792b5c8a98159d3e09294fe5cf651e67273d8f28e24cb57bc00995"
    sha256 cellar: :any,                 arm64_ventura:  "5b48032ccdc363005e2839144d8ddaea81f85f53947cffd0dfaf24baaa1b20bc"
    sha256 cellar: :any,                 arm64_monterey: "595a22c97103a4131cd73df11219065a4b1a5a3f3054bc1771799e1cd5dc1322"
    sha256 cellar: :any,                 sonoma:         "aa110074e8efe4c68559785320d19975c3fbda888cd2db0d71e15ca66893324a"
    sha256 cellar: :any,                 ventura:        "b0ea91e2ed4b9f741461a076659d92506dd31c1fbf6858226d23e77c1311fa46"
    sha256 cellar: :any,                 monterey:       "77d7e4c37b5f6d7cd4a2867662fcd38d199670cf718ffe4ba6615902ca688ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b65edddec7936934aedbc201fff91e7884d7fbc93ca7b1d2c0b0eaa970fca47"
  end

  depends_on "ruby@3.0"

  resource "activesupport" do
    url "https://rubygems.org/gems/activesupport-6.1.7.gem"
    sha256 "f9dee8a4cc315714e29228328428437c8779f58237749339afadbdcfb5c0b74c"
  end

  resource "awesome_print" do
    url "https://rubygems.org/gems/awesome_print-1.9.2.gem"
    sha256 "e99b32b704acff16d768b3468680793ced40bfdc4537eb07e06a4be11133786e"
  end

  resource "faker" do
    url "https://rubygems.org/gems/faker-3.2.1.gem"
    sha256 "d6b201b520213f6d985ac9f9f810154397a146ca22c1d3ff0a6504ef37c5517b"
  end

  resource "launchy" do
    url "https://rubygems.org/gems/launchy-2.5.2.gem"
    sha256 "8aa0441655aec5514008e1d04892c2de3ba57bd337afb984568da091121a241b"
  end

  resource "minitar" do
    url "https://rubygems.org/gems/minitar-0.9.gem"
    sha256 "23c0bebead35dbfe9e24088dc436c8a233d03f51d365a686b9a11dd30dc2d588"
  end

  resource "securerandom" do
    url "https://rubygems.org/gems/securerandom-0.2.2.gem"
    sha256 "5fcb3b8aa050bac5de93a5e22b69483856f70d43affeb883bce0c58d71360131"
  end

  resource "sentry-ruby" do
    url "https://rubygems.org/gems/sentry-ruby-5.12.0.gem"
    sha256 "2a8c161a9e5af6e8af251a778b5692fa3bfaf355a9cf83857eeef9f84e0e649a"
  end

  resource "thor" do
    url "https://rubygems.org/gems/thor-1.2.1.gem"
    sha256 "b1752153dc9c6b8d3fcaa665e9e1a00a3e73f28da5e238b81c404502e539d446"
  end

  resource "tty-prompt" do
    url "https://rubygems.org/gems/tty-prompt-0.23.1.gem"
    sha256 "fcdbce905238993f27eecfdf67597a636bc839d92192f6a0eef22b8166449ec8"
  end

  resource "tty-spinner" do
    url "https://rubygems.org/gems/tty-spinner-0.9.3.gem"
    sha256 "0e036f047b4ffb61f2aa45f5a770ec00b4d04130531558a94bfc5b192b570542"
  end

  resource "uffizzi-cli" do
    url "https://rubygems.org/gems/uffizzi-cli-2.3.2.gem"
    sha256 "40194fe562248cecd26edc3fdbf34171ef0d0c02a13a4b20ed290300f69e965f"
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--no-document", "--install-dir", libexec
    end

    bin.install Dir["#{libexec}/bin/*"]

    bin.env_script_all_files(libexec, GEM_HOME: ENV["GEM_HOME"], GEM_PATH: ENV["GEM_PATH"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uffizzi version")
    server_url = "https://example.com"
    system bin/"uffizzi config set server #{server_url}"
    assert_match server_url, shell_output("#{bin}/uffizzi config get-value server")
  end
end