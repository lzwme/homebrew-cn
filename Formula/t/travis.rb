class Travis < Formula
  desc "Command-line client for Travis CI"
  homepage "https:github.comtravis-citravis.rb"
  url "https:github.comtravis-citravis.rbarchiverefstagsv1.14.0.tar.gz"
  sha256 "6fe418bf33b025a106dd99762aa8ebc595b4b549d4087c6921d5565b741f7361"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "36c4e4ec1af82812623a0e6fba9333b536eb215ec0956a33215eebcc5aedeb55"
    sha256 cellar: :any,                 arm64_sonoma:   "5766618d480fb76e3005eba00f3a7a7ed5a7d51dfc324371d72babe0c4ff3910"
    sha256 cellar: :any,                 arm64_ventura:  "159636202070bdb08a71e8536d3f3fec6a1c1cb2337f7e7155541069eae7db65"
    sha256 cellar: :any,                 arm64_monterey: "d29494581f310f89b031c7890aa97f543135142ab5358b4822354091c6691c25"
    sha256 cellar: :any,                 sonoma:         "644741937292acf07e3906cb16e5da38f6f38a3f1b3a5b4b6635e228f5b785ec"
    sha256 cellar: :any,                 ventura:        "8608c07f7223723636ff0f0006e581ca79b192aa43bb4c1a7463f208e7f5efb1"
    sha256 cellar: :any,                 monterey:       "259c73779364bf1ffa6e4742697f16909f84499180cf30b153ee38d146126e7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c12a3598e9cfdf75556100cbd028916085d5de6c6f49c9d50c27f8c5935fe6b"
  end

  depends_on "pkgconf" => :build
  depends_on "ruby"

  uses_from_macos "libffi"

  resource "net-http-pipeline" do
    url "https:rubygems.orggemsnet-http-pipeline-1.0.1.gem"
    sha256 "6923ce2f28bfde589a9f385e999395eead48ccfe4376d4a85d9a77e8c7f0b22f"
  end

  resource "connection_pool" do
    url "https:rubygems.orggemsconnection_pool-2.4.1.gem"
    sha256 "0f40cf997091f1f04ff66da67eabd61a9fe0d4928b9a3645228532512fab62f4"
  end

  resource "net-http-persistent" do
    url "https:rubygems.orggemsnet-http-persistent-4.0.2.gem"
    sha256 "03f827a33857b1d56b4e796957ad19bf5b58367d853fd0a224eb70fba8d02a44"
  end

  resource "multi_json" do
    url "https:rubygems.orggemsmulti_json-1.15.0.gem"
    sha256 "1fd04138b6e4a90017e8d1b804c039031399866ff3fbabb7822aea367c78615d"
  end

  resource "ffi" do
    url "https:rubygems.orggemsffi-1.16.3.gem"
    sha256 "6d3242ff10c87271b0675c58d68d3f10148fabc2ad6da52a18123f06078871fb"
  end

  resource "ethon" do
    url "https:rubygems.orggemsethon-0.16.0.gem"
    sha256 "bba0da1cea8ac3e1f5cdd7cb1cb5fc78d7ac562c33736f18f0c3eb2b63053d9e"
  end

  resource "typhoeus" do
    url "https:rubygems.orggemstyphoeus-1.4.1.gem"
    sha256 "1c17db8364bd45ab302dc61e460173c3e69835896be88a3df07c206d5c55ef7c"
  end

  resource "ruby2_keywords" do
    url "https:rubygems.orggemsruby2_keywords-0.0.5.gem"
    sha256 "ffd13740c573b7301cf7a2e61fc857b2a8e3d3aff32545d6f8300d8bae10e3ef"
  end

  resource "faraday-net_http" do
    url "https:rubygems.orggemsfaraday-net_http-3.0.2.gem"
    sha256 "6882929abed8094e1ee30344a3369e856fe34530044630d1f652bf70ebd87e8d"
  end
  resource "base64" do
    url "https:rubygems.orggemsbase64-0.2.0.gem"
    sha256 "0f25e9b21a02a0cc0cea8ef92b2041035d39350946e8789c562b2d1a3da01507"
  end

  resource "faraday" do
    url "https:rubygems.orggemsfaraday-2.7.12.gem"
    sha256 "ed38dcd396d2defcf8a536bbf7ef45e6385392ab815fe087df46777be3a781a7"
  end

  resource "faraday-typhoeus" do
    url "https:rubygems.orggemsfaraday-typhoeus-1.1.0.gem"
    sha256 "24c6147c213818dde3ebc50ae47ab92f9a7e554903aa362707126f749c6890e7"
  end

  resource "faraday-retry" do
    url "https:rubygems.orggemsfaraday-retry-2.2.1.gem"
    sha256 "4146fed14549c0580bf14591fca419a40717de0dd24f267a8ec2d9a728677608"
  end

  resource "public_suffix" do
    url "https:rubygems.orggemspublic_suffix-5.0.5.gem"
    sha256 "72c340218bb384610536919988705cc29e09749c0021fd7005f715c7e5dfc493"
  end

  resource "addressable" do
    url "https:rubygems.orgdownloadsaddressable-2.8.6.gem"
    sha256 "798f6af3556641a7619bad1dce04cdb6eb44b0216a991b0396ea7339276f2b47"
  end

  resource "minitest" do
    url "https:rubygems.orgdownloadsminitest-5.20.0.gem"
    sha256 "a3faf26a757ced073aaae0bd10481340f53e221a4f50d8a6033591555374752e"
  end

  resource "concurrent-ruby" do
    url "https:rubygems.orggemsconcurrent-ruby-1.3.1.gem"
    sha256 "c369f1d0875b42295fe0fabc321065f3cfeab8c32c526c01b6b05af1efc8b0ce"
  end

  resource "tzinfo" do
    url "https:rubygems.orggemstzinfo-2.0.6.gem"
    sha256 "8daf828cc77bcf7d63b0e3bdb6caa47e2272dcfaf4fbfe46f8c3a9df087a829b"
  end

  resource "i18n" do
    url "https:rubygems.orggemsi18n-1.14.5.gem"
    sha256 "26dcbc05e364b57e27ab430148b3377bc413987d34cc042336271d8f42e9d1b9"
  end

  resource "activesupport" do
    url "https:rubygems.orggemsactivesupport-7.0.8.3.gem"
    sha256 "233d1f2b0e3e473ed03e8dadbda8feb249bef424c3baf8bd64af6b1fe3bb6af9"
  end

  resource "travis-gh" do
    url "https:rubygems.orggemstravis-gh-0.21.0.gem"
    sha256 "43265fdd15eab3a19422faf442cdf8f0508500542e835cd3cdc1029fe73f7a5b"
  end

  resource "rack" do
    url "https:rubygems.orggemsrack-3.0.11.gem"
    sha256 "a08473678160760d9085ebe14508a42add18cde4217107b4b1aa01c8f14ff98c"
  end

  resource "rack-test" do
    url "https:rubygems.orggemsrack-test-2.1.0.gem"
    sha256 "0c61fc61904049d691922ea4bb99e28004ed3f43aa5cfd495024cc345f125dfb"
  end

  resource "json" do
    url "https:rubygems.orggemsjson-2.7.1.gem"
    sha256 "187ea312fb58420ff0c40f40af1862651d4295c8675267c6a1c353f1a0ac3265"
  end

  resource "websocket" do
    url "https:rubygems.orggemswebsocket-1.2.10.gem"
    sha256 "2cc1a4a79b6e63637b326b4273e46adcddf7871caa5dc5711f2ca4061a629fa8"
  end

  resource "pusher-client" do
    url "https:rubygems.orggemspusher-client-0.6.2.gem"
    sha256 "c405c931090e126c056d99f6b69a01b1bcb6cbfdde02389c93e7d547c6efd5a3"
  end

  resource "launchy" do
    url "https:rubygems.orggemslaunchy-2.5.2.gem"
    sha256 "8aa0441655aec5514008e1d04892c2de3ba57bd337afb984568da091121a241b"
  end

  resource "json_pure" do
    url "https:rubygems.orggemsjson_pure-2.6.3.gem"
    sha256 "c39185aa41c04a1933b8d66d1294224743262ee6881adc7b5a488ab2ae19c74e"
  end

  resource "highline" do
    url "https:rubygems.orggemshighline-2.1.0.gem"
    sha256 "d63d7f472f8ffaa143725161ae6fb06895b5cb7527e0b4dac5ad1e4902c80cb9"
  end

  resource "faraday-rack" do
    url "https:rubygems.orggemsfaraday-rack-2.0.0.gem"
    sha256 "41759651c9e8baba520c21f807a8787dbb8480c2dbe64569264346ffad6b0461"
  end

  def install
    ENV["GEM_HOME"] = libexec
    # gem issue on Mojave
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac? && MacOS.version == :mojave

    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end
    system "gem", "build", "travis.gemspec"
    system "gem", "install", "--ignore-dependencies", "travis-#{version}.gem"
    bin.install libexec"bintravis"
    rm_r(libexec"gemstravis-#{version}assetsnotificationsTravis CI.app")
    bin.env_script_all_files(libexec"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    output = shell_output(bin"travis whoami 2>&1 --pro", 1)
    assert_match "not logged in, please run travis login", output

    output = shell_output("#{bin}travis init 2>&1", 1)
    assert_match "Can't figure out GitHub repo name", output
  end
end