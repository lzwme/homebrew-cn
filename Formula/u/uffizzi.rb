class Uffizzi < Formula
  desc "Self-serve developer platforms in minutes, not months with k8s virtual clusters"
  homepage "https:uffizzi.com"
  url "https:github.comUffizziClouduffizzi_cliarchiverefstagsv2.4.16.tar.gz"
  sha256 "a23f624ce8c8603c51ec0fa73a998d79461ff451effaed3eac07708c1023fc31"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a9690b1dd244207f9deaeb2efc2f6ef96e1a8099b0cf4e9bd6f5870acd0fd670"
    sha256 cellar: :any,                 arm64_sonoma:  "b13844d153cb9639825d2c1929e2043502df1b8c4ff3112c60f37c0348fecb92"
    sha256 cellar: :any,                 arm64_ventura: "972139e7115cf1fb8f473ace660dfe6fb81e440ff11621e7f375b42c370fe9c8"
    sha256 cellar: :any,                 sonoma:        "9bc267353475d5a5ae7d5e36011df34a42ead026760a309ca7c8792966791199"
    sha256 cellar: :any,                 ventura:       "571fb7c79a033b50cb93008d2bb1321cb6985fc5a369604f1da08dcaa266c754"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ac978f08b8ad0982660835fe3ee65e61052e119776d52d8d90f74048e5de717"
  end

  depends_on "ruby"
  depends_on "skaffold"

  conflicts_with "conserver", because: "both install `console` binaries"

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
    url "https:rubygems.orggemsthor-1.3.2.gem"
    sha256 "eef0293b9e24158ccad7ab383ae83534b7ad4ed99c09f96f1a6b036550abbeda"
  end

  resource "bigdecimal" do
    url "https:rubygems.orggemsbigdecimal-3.1.8.gem"
    sha256 "a89467ed5a44f8ae01824af49cbc575871fa078332e8f77ea425725c1ffe27be"
  end

  resource "concurrent-ruby" do
    url "https:rubygems.orggemsconcurrent-ruby-1.3.5.gem"
    sha256 "813b3e37aca6df2a21a3b9f1d497f8cbab24a2b94cab325bffe65ee0f6cbebc6"
  end

  resource "sentry-ruby" do
    url "https:rubygems.orggemssentry-ruby-5.22.4.gem"
    sha256 "e48daf000ab386958a8f8f6c200be29b0b2ef24f23384b7fe7c5eccec091a82c"
  end

  resource "securerandom" do
    url "https:rubygems.orggemssecurerandom-0.4.1.gem"
    sha256 "cc5193d414a4341b6e225f0cb4446aceca8e50d5e1888743fac16987638ea0b1"
  end

  resource "minitar" do
    url "https:rubygems.orggemsminitar-1.0.2.gem"
    sha256 "b192eb2ba7672906ed53853d2188130a849f1c2451e5b2dac688d9f5f7634672"
  end

  resource "logger" do
    url "https:rubygems.orggemslogger-1.6.6.gem"
    sha256 "dd618d24e637715472732e7eed02e33cfbdf56deaad225edd0f1f89d38024017"
  end

  resource "childprocess" do
    url "https:rubygems.orggemschildprocess-5.1.0.gem"
    sha256 "9a8d484be2fd4096a0e90a0cd3e449a05bc3aa33f8ac9e4d6dcef6ac1455b6ec"
  end

  resource "public_suffix" do
    url "https:rubygems.orggemspublic_suffix-6.0.1.gem"
    sha256 "61d44e1cab5cbbbe5b31068481cf16976dd0dc1b6b07bd95617ef8c5e3e00c6f"
  end

  resource "addressable" do
    url "https:rubygems.orggemsaddressable-2.8.7.gem"
    sha256 "462986537cf3735ab5f3c0f557f14155d778f4b43ea4f485a9deb9c8f7c58232"
  end

  resource "launchy" do
    url "https:rubygems.orggemslaunchy-3.1.1.gem"
    sha256 "72b847b5cc961589dde2c395af0108c86ff0119f42d4648d25b5440ebb10059e"
  end

  resource "i18n" do
    url "https:rubygems.orggemsi18n-1.14.7.gem"
    sha256 "ceba573f8138ff2c0915427f1fc5bdf4aa3ab8ae88c8ce255eb3ecf0a11a5d0f"
  end

  resource "faker" do
    url "https:rubygems.orggemsfaker-3.5.1.gem"
    sha256 "1ad1fbea279d882f486059c23fe3ddb816ccd1d7052c05a45014b4450d859bfc"
  end

  resource "awesome_print" do
    url "https:rubygems.orggemsawesome_print-1.9.2.gem"
    sha256 "e99b32b704acff16d768b3468680793ced40bfdc4537eb07e06a4be11133786e"
  end

  resource "benchmark" do
    url "https:rubygems.orggemsbenchmark-0.4.0.gem"
    sha256 "0f12f8c495545e3710c3e4f0480f63f06b4c842cc94cec7f33a956f5180e874a"
  end

  resource "uri" do
    url "https:rubygems.orggemsuri-1.0.2.gem"
    sha256 "b303504ceb7e5905771fa7fa14b649652fa949df18b5880d69cfb12494791e27"
  end

  resource "drb" do
    url "https:rubygems.orggemsdrb-2.2.1.gem"
    sha256 "e9d472bf785f558b96b25358bae115646da0dbfd45107ad858b0bc0d935cb340"
  end

  resource "base64" do
    url "https:rubygems.orggemsbase64-0.2.0.gem"
    sha256 "0f25e9b21a02a0cc0cea8ef92b2041035d39350946e8789c562b2d1a3da01507"
  end

  resource "minitest" do
    url "https:rubygems.orggemsminitest-5.22.3.gem"
    sha256 "ea84676290cb5e2b4f31f25751af6050aa90d3e43e4337141c3e3e839611981e"
  end

  resource "connection_pool" do
    url "https:rubygems.orggemsconnection_pool-2.5.0.gem"
    sha256 "233b92f8d38e038c1349ccea65dd3772727d669d6d2e71f9897c8bf5cd53ebfc"
  end

  resource "tzinfo" do
    url "https:rubygems.orggemstzinfo-2.0.6.gem"
    sha256 "8daf828cc77bcf7d63b0e3bdb6caa47e2272dcfaf4fbfe46f8c3a9df087a829b"
  end

  resource "activesupport" do
    url "https:rubygems.orggemsactivesupport-8.0.1.gem"
    sha256 "fd5bc74641c24ac3541055c2879789198ff42adee3e39c2933289ba008912e37"
  end

  resource "uffizzi-cli" do
    url "https:rubygems.orggemsuffizzi-cli-2.4.16.gem"
    sha256 "36bcf82ee092fb99f9dea6270fafa71bdf9794adc28deccb1ee0288064ed7aa4"
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