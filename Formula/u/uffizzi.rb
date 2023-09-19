class Uffizzi < Formula
  desc "Self-serve developer platforms in minutes, not months with k8s virtual clusters"
  homepage "https://uffizzi.com"
  url "https://ghproxy.com/https://github.com/UffizziCloud/uffizzi_cli/archive/refs/tags/v2.0.36.tar.gz"
  sha256 "83d5b590f4f888638fd347c9b02cb075aaf8943450f799a17bd72db61ef79476"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c64408fadc1c794443ac0e39642f1b53cc18b2159a2c7807265840386fc5881"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c64408fadc1c794443ac0e39642f1b53cc18b2159a2c7807265840386fc5881"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c64408fadc1c794443ac0e39642f1b53cc18b2159a2c7807265840386fc5881"
    sha256 cellar: :any_skip_relocation, ventura:        "b9a5d6f46a4ebafb0f1c52e58dcb643bf0c03beed3a30718cbebc8d0b60b5acd"
    sha256 cellar: :any_skip_relocation, monterey:       "b9a5d6f46a4ebafb0f1c52e58dcb643bf0c03beed3a30718cbebc8d0b60b5acd"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9a5d6f46a4ebafb0f1c52e58dcb643bf0c03beed3a30718cbebc8d0b60b5acd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c64408fadc1c794443ac0e39642f1b53cc18b2159a2c7807265840386fc5881"
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
    url "https://rubygems.org/gems/sentry-ruby-5.11.0.gem"
    sha256 "27f603638d75d28b974def362792f442ae39e3e1c1496427910f9a0f434f3a71"
  end

  resource "thor" do
    url "https://rubygems.org/gems/thor-1.2.2.gem"
    sha256 "2f93c652828cba9fcf4f65f5dc8c306f1a7317e05aad5835a13740122c17f24c"
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
    url "https://rubygems.org/gems/uffizzi-cli-2.0.36.gem"
    sha256 "d1465187e83941b9b1577d4bf072ff2583fe5dd9c4c70970128356c9fd07f19c"
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