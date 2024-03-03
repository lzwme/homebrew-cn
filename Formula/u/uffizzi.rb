class Uffizzi < Formula
  desc "Self-serve developer platforms in minutes, not months with k8s virtual clusters"
  homepage "https:uffizzi.com"
  url "https:github.comUffizziClouduffizzi_cliarchiverefstagsv2.4.7.tar.gz"
  sha256 "5787b48ff15c3e1aa3fb341600184a456aa5622656a6412badf067b62b2f4bfb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "16c5d29308bfe904d97a85167a0176098097def5f37ed8273c890bd9959841b4"
    sha256 cellar: :any,                 arm64_ventura:  "61889fe37384ee3a794932593675f1ad57bf84b07a735794019c8654a9df5c96"
    sha256 cellar: :any,                 arm64_monterey: "7ee906f6e348c9b94e8b0a0f4756bb631b9b6cc9ed4cd89b464b1d73d70d211a"
    sha256 cellar: :any,                 sonoma:         "4945aff3bff259d12a36ebf71d8762622ced6e5d3e3e48716894b892f4ba76cd"
    sha256 cellar: :any,                 ventura:        "18712041f4911942f8ecdad896fbd82e1bf68e74d76773223f15bf2580302571"
    sha256 cellar: :any,                 monterey:       "f58508204406ffe6961cca92c300890178cbb7e171ca48bf67542f003e1e4004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d43f667a5081bab715c1d4b29bfcb76702cd28f5fc4fcb5e331f293e4a92c4d"
  end

  depends_on "ruby"
  depends_on "skaffold"

  # Runtime dependencies of uffizzi
  # List with `gem install --explain uffizzi-cli`
  resource "tty-cursor" do
    url "https:rubygems.orggemstty-cursor-0.7.1.gem"
    sha256 "79534185e6a777888d88628b14b6a1fdf5154a603f285f80b1753e1908e0bf48"
  end

  resource "tty-spinner" do
    url "https:rubygems.orggemstty-spinner-0.9.3.gem"
    sha256 "0e036f047b4ffb61f2aa45f5a770ec00b4d04130531558a94bfc5b192b570542"
  end

  resource "wisper" do
    url "https:rubygems.orggemswisper-2.0.1.gem"
    sha256 "ce17bc5c3a166f241a2e6613848b025c8146fce2defba505920c1d1f3f88fae6"
  end

  resource "tty-screen" do
    url "https:rubygems.orggemstty-screen-0.8.2.gem"
    sha256 "c090652115beae764336c28802d633f204fb84da93c6a968aa5d8e319e819b50"
  end

  resource "tty-reader" do
    url "https:rubygems.orggemstty-reader-0.9.0.gem"
    sha256 "c62972c985c0b1566f0e56743b6a7882f979d3dc32ff491ed490a076f899c2b1"
  end

  resource "tty-color" do
    url "https:rubygems.orggemstty-color-0.6.0.gem"
    sha256 "6f9c37ca3a4e2367fb2e6d09722762647d6f455c111f05b59f35730eeb24332a"
  end

  resource "pastel" do
    url "https:rubygems.orggemspastel-0.8.0.gem"
    sha256 "481da9fb7d2f6e6b1a08faf11fa10363172dc40fd47848f096ae21209f805a75"
  end

  resource "tty-prompt" do
    url "https:rubygems.orggemstty-prompt-0.23.1.gem"
    sha256 "fcdbce905238993f27eecfdf67597a636bc839d92192f6a0eef22b8166449ec8"
  end

  resource "thor" do
    url "https:rubygems.orggemsthor-1.3.1.gem"
    sha256 "fa7e3471d4f6a27138e3d9c9b0d4daac9c3d7383927667ae83e9ab42ae7401ef"
  end

  resource "concurrent-ruby" do
    url "https:rubygems.orggemsconcurrent-ruby-1.2.3.gem"
    sha256 "82fdd3f8a0816e28d513e637bb2b90a45d7b982bdf4f3a0511722d2e495801e2"
  end

  resource "sentry-ruby" do
    url "https:rubygems.orggemssentry-ruby-5.16.1.gem"
    sha256 "767ef1db68d7294cfbfd0fc9e12d7297e452c287243cca71219e2c7b5cd0583b"
  end

  resource "securerandom" do
    url "https:rubygems.orggemssecurerandom-0.3.1.gem"
    sha256 "98f0450c0ea46d2f9a4b6db4f391dbd83dc08049592eada155739f40e0341bde"
  end

  resource "minitar" do
    url "https:rubygems.orggemsminitar-0.9.gem"
    sha256 "23c0bebead35dbfe9e24088dc436c8a233d03f51d365a686b9a11dd30dc2d588"
  end

  resource "public_suffix" do
    url "https:rubygems.orggemspublic_suffix-5.0.4.gem"
    sha256 "35cd648e0d21d06b8dce9331d19619538d1d898ba6d56a6f2258409d2526d1ae"
  end

  resource "addressable" do
    url "https:rubygems.orggemsaddressable-2.8.6.gem"
    sha256 "798f6af3556641a7619bad1dce04cdb6eb44b0216a991b0396ea7339276f2b47"
  end

  resource "launchy" do
    url "https:rubygems.orggemslaunchy-2.5.2.gem"
    sha256 "8aa0441655aec5514008e1d04892c2de3ba57bd337afb984568da091121a241b"
  end

  resource "i18n" do
    url "https:rubygems.orggemsi18n-1.14.1.gem"
    sha256 "9d03698903547c060928e70a9bc8b6b87fda674453cda918fc7ab80235ae4a61"
  end

  resource "faker" do
    url "https:rubygems.orggemsfaker-3.2.3.gem"
    sha256 "ffaf8d7a511f4ae5f5291b92fb306a386a6296765df204a0a4d89750d0813ce7"
  end

  resource "awesome_print" do
    url "https:rubygems.orggemsawesome_print-1.9.2.gem"
    sha256 "e99b32b704acff16d768b3468680793ced40bfdc4537eb07e06a4be11133786e"
  end

  resource "tzinfo" do
    url "https:rubygems.orggemstzinfo-2.0.6.gem"
    sha256 "8daf828cc77bcf7d63b0e3bdb6caa47e2272dcfaf4fbfe46f8c3a9df087a829b"
  end

  resource "mutex_m" do
    url "https:rubygems.orggemsmutex_m-0.2.0.gem"
    sha256 "b6ef0c6c842ede846f2ec0ade9e266b1a9dac0bc151682b04835e8ebd54840d5"
  end

  resource "minitest" do
    url "https:rubygems.orggemsminitest-5.20.0.gem"
    sha256 "a3faf26a757ced073aaae0bd10481340f53e221a4f50d8a6033591555374752e"
  end

  resource "ruby2_keywords" do
    url "https:rubygems.orggemsruby2_keywords-0.0.5.gem"
    sha256 "ffd13740c573b7301cf7a2e61fc857b2a8e3d3aff32545d6f8300d8bae10e3ef"
  end

  resource "drb" do
    url "https:rubygems.orggemsdrb-2.2.0.gem"
    sha256 "e9e4af1cded3306cfe37e064a0086e302d5f40df9cb4d161d059a6bb3a75d40f"
  end

  resource "connection_pool" do
    url "https:rubygems.orggemsconnection_pool-2.4.1.gem"
    sha256 "0f40cf997091f1f04ff66da67eabd61a9fe0d4928b9a3645228532512fab62f4"
  end

  resource "bigdecimal" do
    url "https:rubygems.orggemsbigdecimal-3.1.6.gem"
    sha256 "bcbc27d449cf8ed1b1814d21308f49c9d22ce73e33fff0d228e38799c02eab01"
  end

  resource "base64" do
    url "https:rubygems.orggemsbase64-0.2.0.gem"
    sha256 "0f25e9b21a02a0cc0cea8ef92b2041035d39350946e8789c562b2d1a3da01507"
  end

  resource "activesupport" do
    url "https:rubygems.orggemsactivesupport-7.1.3.2.gem"
    sha256 "ad8445b7ae4a6d3acc5f88c8c5f437eb0b54062032aaf44856c7b6d3855b8b2e"
  end

  resource "uffizzi-cli" do
    url "https:rubygems.orggemsuffizzi-cli-2.4.7.gem"
    sha256 "fa3364b0e8888eeead5787c626dd71d5e1aae1dfb6466fc2c40c842028c46b1b"
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--no-document", "--install-dir", libexec
    end

    bin.install Dir["#{libexec}bin*"]

    bin.env_script_all_files(libexec, GEM_HOME: ENV["GEM_HOME"], GEM_PATH: ENV["GEM_PATH"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}uffizzi version")
    server_url = "https:example.com"
    system bin"uffizzi config set server #{server_url}"
    assert_match server_url, shell_output("#{bin}uffizzi config get-value server")
  end
end