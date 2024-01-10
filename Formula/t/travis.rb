class Travis < Formula
  desc "Command-line client for Travis CI"
  homepage "https:github.comtravis-citravis.rb"
  url "https:github.comtravis-citravis.rbarchiverefstagsv1.11.1.tar.gz"
  sha256 "438b30362b54ed5c8668abf4212f239ac9081ab3aeb7cb9a24a9bf4b044495c3"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2f65f4d4c87f7e495738447c4611e3185daae3843c43598c7a6579813b031b23"
    sha256 cellar: :any,                 arm64_ventura:  "97f5a55d76e5705fbd115b1245e3d3298ac5aa264ff6c11fe8d95f4edd246624"
    sha256 cellar: :any,                 arm64_monterey: "806951224f44ededcaa6133aa5a327f25b23fcd12eca6680f686070a1c0792dc"
    sha256 cellar: :any,                 sonoma:         "525ce73c6bf2b3eab4656b1698acebef0b8b5478d987d898e9b4116585dbbb34"
    sha256 cellar: :any,                 ventura:        "6268c5e6afda03121560a8fe7070161a51345a116b3edb2f2c8d1c576656bf99"
    sha256 cellar: :any,                 monterey:       "94175386e959e0bf8aaa1400dca6d198059334541a04b58d72a6dff465f2afac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b18c8115c15be6aecd5784e38cc18676fe81a6dc095ea51bf5c5fea8b3ad8648"
  end

  depends_on "pkg-config" => :build
  depends_on "ruby"

  resource "activesupport" do
    url "https:rubygems.orggemsactivesupport-5.2.8.1.gem"
    sha256 "f0498c616e1b243c7b56d67920c389f959c186ad7031569e80335b42e1d22564"
  end

  resource "addressable" do
    url "https:rubygems.orggemsaddressable-2.8.0.gem"
    sha256 "f76d29d2d1f54b6c6a49aec58f9583b08d97e088c227a3fcba92f6c6531d5908"
  end

  resource "concurrent-ruby" do
    url "https:rubygems.orggemsconcurrent-ruby-1.1.10.gem"
    sha256 "244cb1ca0d91ec2c15ca2209507c39fb163336994428e16fbd3f465c87bd8e68"
  end

  resource "faraday" do
    url "https:rubygems.orggemsfaraday-1.10.1.gem"
    sha256 "38e5d43359ad0e8579af549fcc6083c03ffbeb0dd6fd78dee359263fde2cfc0c"
  end

  resource "faraday-em_http" do
    url "https:rubygems.orggemsfaraday-em_http-1.0.0.gem"
    sha256 "7a3d4c7079789121054f57e08cd4ef7e40ad1549b63101f38c7093a9d6c59689"
  end

  resource "faraday-em_synchrony" do
    url "https:rubygems.orggemsfaraday-em_synchrony-1.0.0.gem"
    sha256 "460dad1c30cc692d6e77d4c391ccadb4eca4854b315632cd7e560f74275cf9ed"
  end

  resource "faraday-excon" do
    url "https:rubygems.orggemsfaraday-excon-1.1.0.gem"
    sha256 "b055c842376734d7f74350fe8611542ae2000c5387348d9ba9708109d6e40940"
  end

  resource "faraday-httpclient" do
    url "https:rubygems.orggemsfaraday-httpclient-1.0.1.gem"
    sha256 "4c8ff1f0973ff835be8d043ef16aaf54f47f25b7578f6d916deee8399a04d33b"
  end

  resource "faraday-multipart" do
    url "https:rubygems.orggemsfaraday-multipart-1.0.4.gem"
    sha256 "9012021ab57790f7d712f590b48d5f948b19b43cfa11ca83e6459f06090b0725"
  end

  resource "faraday-net_http" do
    url "https:rubygems.orggemsfaraday-net_http-1.0.1.gem"
    sha256 "3245ce406ebb77b40e17a77bfa66191dda04be2fd4e13a78d8a4305854d328ba"
  end

  resource "faraday-net_http_persistent" do
    url "https:rubygems.orggemsfaraday-net_http_persistent-1.2.0.gem"
    sha256 "0b0cbc8f03dab943c3e1cc58d8b7beb142d9df068b39c718cd83e39260348335"
  end

  resource "faraday-patron" do
    url "https:rubygems.orggemsfaraday-patron-1.0.0.gem"
    sha256 "dc2cd7b340bb3cc8e36bcb9e6e7eff43d134b6d526d5f3429c7a7680ddd38fa7"
  end

  resource "faraday-rack" do
    url "https:rubygems.orggemsfaraday-rack-1.0.0.gem"
    sha256 "ef60ec969a2bb95b8dbf24400155aee64a00fc8ba6c6a4d3968562bcc92328c0"
  end

  resource "faraday-retry" do
    url "https:rubygems.orggemsfaraday-retry-1.0.3.gem"
    sha256 "add154f4f399243cbe070806ed41b96906942e7f5259bb1fe6daf2ec8f497194"
  end

  resource "faraday_middleware" do
    url "https:rubygems.orggemsfaraday_middleware-1.2.0.gem"
    sha256 "ded15d574d50e92bd04448d5566913af5cb1a01b2fa311ceecc2464fa0ab88af"
  end

  resource "gh" do
    url "https:rubygems.orggemsgh-0.18.0.gem"
    sha256 "eb93f18a88db3ba92eb888610fc53fae731d9dacfe55922b58cc3f3aca776a47"
  end

  resource "highline" do
    url "https:rubygems.orggemshighline-2.0.3.gem"
    sha256 "2ddd5c127d4692721486f91737307236fe005352d12a4202e26c48614f719479"
  end

  resource "i18n" do
    url "https:rubygems.orggemsi18n-1.12.0.gem"
    sha256 "91e3cc1b97616d308707eedee413d82ee021d751c918661fb82152793e64aced"
  end

  resource "json" do
    url "https:rubygems.orggemsjson-2.6.2.gem"
    sha256 "940dc787e33d7e846898724331c9463fd89b54602ff5ed6561f3eaed4168657a"
  end

  resource "json_pure" do
    url "https:rubygems.orggemsjson_pure-2.6.2.gem"
    sha256 "ccf59aeb76249a17d894f0a974073d1264645528f0799a59c52b01560da3a811"
  end

  resource "launchy" do
    url "https:rubygems.orggemslaunchy-2.4.3.gem"
    sha256 "42f52ce12c6fe079bac8a804c66522a0eefe176b845a62df829defe0e37214a4"
  end

  resource "minitest" do
    url "https:rubygems.orggemsminitest-5.16.2.gem"
    sha256 "c1be0c6b57fab451faa08e74ffa71e7d6a259b90f4bacb881c7f4808ec8b4991"
  end

  resource "multi_json" do
    url "https:rubygems.orggemsmulti_json-1.15.0.gem"
    sha256 "1fd04138b6e4a90017e8d1b804c039031399866ff3fbabb7822aea367c78615d"
  end

  resource "multipart-post" do
    url "https:rubygems.orggemsmultipart-post-2.2.3.gem"
    sha256 "462979de2971b8df33c2ee797fd497731617241f9dcd93960cc3caccb2dd13d8"
  end

  resource "net-http-persistent" do
    url "https:rubygems.orggemsnet-http-persistent-2.9.4.gem"
    sha256 "24274d207ffe66222ef70c78a052c7ea6e66b4ff21e2e8a99e3335d095822ef9"
  end

  resource "net-http-pipeline" do
    url "https:rubygems.orggemsnet-http-pipeline-1.0.1.gem"
    sha256 "6923ce2f28bfde589a9f385e999395eead48ccfe4376d4a85d9a77e8c7f0b22f"
  end

  resource "public_suffix" do
    url "https:rubygems.orggemspublic_suffix-4.0.7.gem"
    sha256 "8be161e2421f8d45b0098c042c06486789731ea93dc3a896d30554ee38b573b8"
  end

  resource "pusher-client" do
    url "https:rubygems.orggemspusher-client-0.6.2.gem"
    sha256 "c405c931090e126c056d99f6b69a01b1bcb6cbfdde02389c93e7d547c6efd5a3"
  end

  resource "ruby2_keywords" do
    url "https:rubygems.orggemsruby2_keywords-0.0.5.gem"
    sha256 "ffd13740c573b7301cf7a2e61fc857b2a8e3d3aff32545d6f8300d8bae10e3ef"
  end

  resource "thread_safe" do
    url "https:rubygems.orggemsthread_safe-0.3.6.gem"
    sha256 "9ed7072821b51c57e8d6b7011a8e282e25aeea3a4065eab326e43f66f063b05a"
  end

  resource "tzinfo" do
    url "https:rubygems.orggemstzinfo-1.2.10.gem"
    sha256 "c6d3fa6e6de19744171536dc1bd1142442f3f265efabe8d9f28c03f9874f8867"
  end

  resource "websocket" do
    url "https:rubygems.orggemswebsocket-1.2.9.gem"
    sha256 "884b12dee993217795bb5f58acc89c0121c88bdc99df4d1636c0505dca352b36"
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
    (libexec"gemstravis-#{version}assetsnotificationsTravis CI.app").rmtree
    bin.env_script_all_files(libexec"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    output = shell_output(bin"travis whoami 2>&1 --pro", 1)
    assert_match "not logged in, please run travis login --pro", output

    output = shell_output("#{bin}travis init 2>&1", 1)
    assert_match "Can't figure out GitHub repo name", output
  end
end