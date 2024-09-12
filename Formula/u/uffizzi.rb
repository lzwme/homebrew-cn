class Uffizzi < Formula
  desc "Self-serve developer platforms in minutes, not months with k8s virtual clusters"
  homepage "https:uffizzi.com"
  url "https:github.comUffizziClouduffizzi_cliarchiverefstagsv2.4.11.tar.gz"
  sha256 "90c6d9bf225bc759c56188039e5aa9267b91cb78f0496ee6af0a4e2ce3e31430"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b22c38d2105c9e5aa905523ca1179202f2aa987c6c7ae97341ef472e77db35fd"
    sha256 cellar: :any,                 arm64_sonoma:   "c0b2c5f83812a149c776fe7e98607f47d260c5f9011906b1a94d9c921f0c2eba"
    sha256 cellar: :any,                 arm64_ventura:  "2f52c0d4a6529cabb2a0433c49ca06ecc5c0c56e39db2eea2e2405572aba188d"
    sha256 cellar: :any,                 arm64_monterey: "f810f30435e058488f29c9019aad3b48976894243ed99c9738803f91c31a0ffa"
    sha256 cellar: :any,                 sonoma:         "be23cbe46234971df401a29e135da1748c15d164d6c02ae4dd6b30348aad8e32"
    sha256 cellar: :any,                 ventura:        "77d743e634299ee4e05e74d0ae5e20e019e96e173387044157c7f401f35bad96"
    sha256 cellar: :any,                 monterey:       "a630714e4ff38983547b92dfaecd2bcc972d99ed6da0a6a051b0a46f8a42c03b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ae4c858d28cef6edb96bb2087ec3369239d50fb0305225acb418d4cfa3a3923"
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
    url "https:rubygems.orggemsthor-1.3.1.gem"
    sha256 "fa7e3471d4f6a27138e3d9c9b0d4daac9c3d7383927667ae83e9ab42ae7401ef"
  end

  resource "concurrent-ruby" do
    url "https:rubygems.orggemsconcurrent-ruby-1.2.3.gem"
    sha256 "82fdd3f8a0816e28d513e637bb2b90a45d7b982bdf4f3a0511722d2e495801e2"
  end

  resource "bigdecimal" do
    url "https:rubygems.orggemsbigdecimal-3.1.8.gem"
    sha256 "a89467ed5a44f8ae01824af49cbc575871fa078332e8f77ea425725c1ffe27be"
  end

  resource "sentry-ruby" do
    url "https:rubygems.orggemssentry-ruby-5.18.2.gem"
    sha256 "df25cb1bd0c6b23f3266e4a77e9b8efd76d41e1680b07b17d257a99262c10d99"
  end

  resource "securerandom" do
    url "https:rubygems.orggemssecurerandom-0.3.1.gem"
    sha256 "98f0450c0ea46d2f9a4b6db4f391dbd83dc08049592eada155739f40e0341bde"
  end

  resource "minitar" do
    url "https:rubygems.orggemsminitar-0.9.gem"
    sha256 "23c0bebead35dbfe9e24088dc436c8a233d03f51d365a686b9a11dd30dc2d588"
  end

  resource "childprocess" do
    url "https:rubygems.orggemschildprocess-5.0.0.gem"
    sha256 "0746b7ab1d6c68156e64a3767631d7124121516192c0492929a7f0af7310d835"
  end

  resource "public_suffix" do
    url "https:rubygems.orggemspublic_suffix-5.0.5.gem"
    sha256 "72c340218bb384610536919988705cc29e09749c0021fd7005f715c7e5dfc493"
  end

  resource "addressable" do
    url "https:rubygems.orggemsaddressable-2.8.6.gem"
    sha256 "798f6af3556641a7619bad1dce04cdb6eb44b0216a991b0396ea7339276f2b47"
  end

  resource "launchy" do
    url "https:rubygems.orggemslaunchy-3.0.0.gem"
    sha256 "4abcdab659689550ceca6ec0630cd9efd9940b51dc14cb4ebceee8f7aedc791b"
  end

  resource "i18n" do
    url "https:rubygems.orggemsi18n-1.14.4.gem"
    sha256 "c7deedead0866ea9102975a4eab7968f53de50793a0c211a37808f75dd187551"
  end

  resource "faker" do
    url "https:rubygems.orggemsfaker-3.4.2.gem"
    sha256 "516b5a342020e6286b061084d7a60c848c024e9c91f7db6f94bf5bab45ef40f6"
  end

  resource "awesome_print" do
    url "https:rubygems.orggemsawesome_print-1.9.2.gem"
    sha256 "e99b32b704acff16d768b3468680793ced40bfdc4537eb07e06a4be11133786e"
  end

  resource "mutex_m" do
    url "https:rubygems.orggemsmutex_m-0.2.0.gem"
    sha256 "b6ef0c6c842ede846f2ec0ade9e266b1a9dac0bc151682b04835e8ebd54840d5"
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
    url "https:rubygems.orggemsconnection_pool-2.4.1.gem"
    sha256 "0f40cf997091f1f04ff66da67eabd61a9fe0d4928b9a3645228532512fab62f4"
  end

  resource "tzinfo" do
    url "https:rubygems.orggemstzinfo-2.0.6.gem"
    sha256 "8daf828cc77bcf7d63b0e3bdb6caa47e2272dcfaf4fbfe46f8c3a9df087a829b"
  end

  resource "activesupport" do
    url "https:rubygems.orggemsactivesupport-7.1.3.2.gem"
    sha256 "ad8445b7ae4a6d3acc5f88c8c5f437eb0b54062032aaf44856c7b6d3855b8b2e"
  end

  resource "uffizzi-cli" do
    url "https:rubygems.orggemsuffizzi-cli-2.4.11.gem"
    sha256 "85a8bad87be98c1f9dbb13c9f5266236baf07a2f3a658e6e9ffb70fdeb0a0fd1"
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