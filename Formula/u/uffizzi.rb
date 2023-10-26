class Uffizzi < Formula
  desc "Self-serve developer platforms in minutes, not months with k8s virtual clusters"
  homepage "https://uffizzi.com"
  url "https://ghproxy.com/https://github.com/UffizziCloud/uffizzi_cli/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "59896c1646c8cd9261b32154efbd063fba507382899e1377f2369fb0e58b608b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b2db5d6504f33d06f01dd2e47a75bab87ae2d1144c9a75c7961a137ff58eb38b"
    sha256 cellar: :any,                 arm64_ventura:  "6f8f9c163fd19c0eada45655919308d5cc1970daba6c60cf12769584422ad94a"
    sha256 cellar: :any,                 arm64_monterey: "417b53a4f1f36fde6f49b621d95bd3675872890096202117134adcf6672bb886"
    sha256 cellar: :any,                 sonoma:         "9be850b8f8f1322f358d0d07d01f692c1f2728b77917c23076bae9c004173a3a"
    sha256 cellar: :any,                 ventura:        "365a33db90f25d3db67fb6b9b7167725f0127dc3ef2ad9edbf447660ce39e4db"
    sha256 cellar: :any,                 monterey:       "e201f52373d09eecb04e0175b95966d6c6bb009bd1d9c26378da0ba1903bef49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9308d4c7b90fa57fa8a4a00206925e6c8859834c83b36b0cacc92d32aec00b5"
  end

  depends_on "ruby@3.0"

  resource "activesupport" do
    url "https://rubygems.org/gems/activesupport-6.1.4.1.gem"
    sha256 "44b781877c2189aa15ca5451e2d310dcedfd16c01df1106f68a91b82990cfda5"
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
    url "https://rubygems.org/gems/thor-1.3.0.gem"
    sha256 "1adc7f9e5b3655a68c71393fee8bd0ad088d14ee8e83a0b73726f23cbb3ca7c3"
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
    url "https://rubygems.org/gems/uffizzi-cli-2.2.2.gem"
    sha256 "287690243c2e9bfc29c5cba33153ae89426773d9f45cb2944ca2d75b6ddba971"
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