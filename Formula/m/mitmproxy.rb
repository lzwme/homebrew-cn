class Mitmproxy < Formula
  include Language::Python::Virtualenv

  desc "Intercept, modify, replay, save HTTP/S traffic"
  homepage "https://mitmproxy.org"
  url "https://ghproxy.com/https://github.com/mitmproxy/mitmproxy/archive/refs/tags/10.0.0.tar.gz"
  sha256 "c1884a3b6c33dca05488e483f19dd13cefac6367e16bdf5961c8a9ff4105b9cc"
  license "MIT"
  head "https://github.com/mitmproxy/mitmproxy.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "ce482e68207cf11a5f8326f549c54ae58741c638f599d03500202683669c13f5"
    sha256 cellar: :any,                 arm64_ventura:  "b1d0cbd66f78ed043a9bc2b2c7fdfffde6a6761b8d8f58ec6a4062fd5808c24c"
    sha256 cellar: :any,                 arm64_monterey: "5592ba12806a558361e4e1d4ac827f8f2cb0816acc9f71c3dc0b1104bf0be522"
    sha256 cellar: :any,                 sonoma:         "b9d926cb268655dae5846620e57d0c8508649233d10bb3c9053ac0f0d6fbdf8d"
    sha256 cellar: :any,                 ventura:        "c8b57c74bc98e48a8b5d0cafdf4d338342f2952bdbb04519464163df9889b8fd"
    sha256 cellar: :any,                 monterey:       "7056ae01af495f0c3b1fc90053a071d33963832d0617404d59e070dd44cc7387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23395280ed210ef34050a92a6c911c6a7a953a5c6b7149117aad7662c0696c70"
  end

  depends_on "rust" => :build # for mitmproxy-wireguard
  depends_on "cffi"
  depends_on "protobuf"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-cryptography"
  depends_on "python-markupsafe"
  depends_on "python-pyparsing"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  resource "aioquic-mitmproxy" do
    url "https://files.pythonhosted.org/packages/8f/cd/48c08c74f16d90f6a85ce74f4700cc7dea807e6e880f97b2d460dc9470b5/aioquic_mitmproxy-0.9.20.3.tar.gz"
    sha256 "a1ea39e34432c3d1216358e773d416d07717cdda86445909c1e23aec75dd5d75"
  end

  resource "asgiref" do
    url "https://files.pythonhosted.org/packages/12/19/64e38c1c2cbf0da9635b7082bbdf0e89052e93329279f59759c24a10cc96/asgiref-3.7.2.tar.gz"
    sha256 "9e0ce3aa93a819ba5b45120216b23878cf6e8525eb3848653452b4192b92afed"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/ea/96/ed1420a974540da7419094f2553bc198c454cee5f72576e7c7629dd12d6e/blinker-1.6.3.tar.gz"
    sha256 "152090d27c1c5c722ee7e48504b02d76502811ce02e1523553b4cf8c8b3d3a8d"
  end

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2a/18/70c32fe9357f3eea18598b23aa9ed29b1711c3001835f7cf99a9818985d0/Brotli-1.0.9.zip"
    sha256 "4d1b810aa0ed773f81dceda2cc7b403d01057458730e309856356d4ef4188438"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/46/b7/4ace17e37abd9c21715dea5ee11774a25e404c486a7893fa18e764326ead/flask-2.3.3.tar.gz"
    sha256 "09c347a92aa7ff4a8e7f3206795f30d826654baf38b873d0744cd571ca609efc"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/2a/32/fec683ddd10629ea4ea46d206752a95a2d8a48c22521edd70b142488efe1/h2-4.1.0.tar.gz"
    sha256 "a83aca08fbe7aacb79fec788c9c0bac936343560ed9ec18b82a13a12c28d2abb"
  end

  resource "hpack" do
    url "https://files.pythonhosted.org/packages/3e/9b/fda93fb4d957db19b0f6b370e79d586b3e8528b20252c729c476a2c02954/hpack-4.0.0.tar.gz"
    sha256 "fc41de0c63e687ebffde81187a948221294896f6bdc0ae2312708df339430095"
  end

  resource "hyperframe" do
    url "https://files.pythonhosted.org/packages/5a/2a/4747bff0a17f7281abe73e955d60d80aae537a5d203f417fa1c2e7578ebb/hyperframe-6.0.1.tar.gz"
    sha256 "ae510046231dc8e9ecb1a6586f63d2347bf4c8905914aa84ba585ae85f28a914"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/7f/a1/d3fb83e7a61fa0c0d3d08ad0a94ddbeff3731c05212617dff3a94e097f08/itsdangerous-2.1.2.tar.gz"
    sha256 "5dbbc68b317e5e42f327f9021763545dc3fc3bfe22e6deb96aaf1fc38874156a"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "kaitaistruct" do
    url "https://files.pythonhosted.org/packages/54/04/dd60b9cb65d580ef6cb6eaee975ad1bdd22d46a3f51b07a1e0606710ea88/kaitaistruct-0.10.tar.gz"
    sha256 "a044dee29173d6afbacf27bcac39daf89b654dd418cfa009ab82d9178a9ae52a"
  end

  resource "ldap3" do
    url "https://files.pythonhosted.org/packages/43/ac/96bd5464e3edbc61595d0d69989f5d9969ae411866427b2500a8e5b812c0/ldap3-2.9.1.tar.gz"
    sha256 "f3e7fc4718e3f09dda568b57100095e0ce58633bcabbed8667ce3f8fbaa4229f"
  end

  resource "mitmproxy-rs" do
    url "https://files.pythonhosted.org/packages/d5/94/8ebe25c964595b6394201a96083631f43d87b86c5cea70bfdcc09790923f/mitmproxy_rs-0.2.2.tar.gz"
    sha256 "64493b1aeb13d1c1f0d746fc8633d3ba378788cdb689f408683cd0c4783a872f"

    # Allow brewed `protoc` to be used. Patch adjusted to match path in tarball.
    # Upstream PR: https://github.com/mitmproxy/mitmproxy_rs/pull/85
    patch :DATA
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/c2/d5/5662032db1571110b5b51647aed4b56dfbd01bfae789fa566a2be1f385d1/msgpack-1.0.7.tar.gz"
    sha256 "572efc93db7a4d27e404501975ca6d2d9775705c2d922390d878fcf768d92c87"
  end

  resource "passlib" do
    url "https://files.pythonhosted.org/packages/b6/06/9da9ee59a67fae7761aab3ccc84fa4f3f33f125b370f1ccdb915bf967c11/passlib-1.7.4.tar.gz"
    sha256 "defd50f72b65c5402ab2c573830a6978e5f202ad0d984793c8dde2c4152ebe04"
  end

  resource "publicsuffix2" do
    url "https://files.pythonhosted.org/packages/5a/04/1759906c4c5b67b2903f546de234a824d4028ef24eb0b1122daa43376c20/publicsuffix2-2.20191221.tar.gz"
    sha256 "00f8cc31aa8d0d5592a5ced19cccba7de428ebca985db26ac852d920ddd6fe7b"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/61/ef/945a8bcda7895717c8ba4688c08a11ef6454f32b8e5cb6e352a9004ee89d/pyasn1-0.5.0.tar.gz"
    sha256 "97b7290ca68e62a832558ec3976f15cbf911bf5d7c7039d8b861c2a0ece69fde"
  end

  resource "pylsqpack" do
    url "https://files.pythonhosted.org/packages/40/15/e38751187d1db74efce30d45e72ae0035e506101585e28eee525bc465f7e/pylsqpack-0.3.17.tar.gz"
    sha256 "2f20778db956dc7e4b1a8a79722d57a4650c45997fb65c1352cbf85eb7aa3ce2"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/be/df/75a6525d8988a89aed2393347e9db27a56cb38a3e864314fac223e905aef/pyOpenSSL-23.2.0.tar.gz"
    sha256 "276f931f55a452e7dea69c7173e984eb2a4407ce413c918aa34b55f82f9b8bac"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/d1/d6/eb2833ccba5ea36f8f4de4bcfa0d1a91eb618f832d430b70e3086821f251/ruamel.yaml-0.17.40.tar.gz"
    sha256 "6024b986f06765d482b5b07e086cc4b4cd05dd22ddcbc758fa23d54873cf313d"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/46/ab/bab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295b/ruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/48/64/679260ca0c3742e2236c693dc6c34fb8b153c14c21d2aa2077c5a01924d6/tornado-6.3.3.tar.gz"
    sha256 "e7d8db41c0181c80d76c982aacc442c0783a2c54d6400fe028954201a2e032fe"
  end

  resource "urwid-mitmproxy" do
    url "https://files.pythonhosted.org/packages/e7/f8/f2e8fe84e413eed791c8eb45b2a7d9937b607e9b7d402b123c9849247a7d/urwid-mitmproxy-2.1.2.1.tar.gz"
    sha256 "be6238e587acb92bdd43b241af0a10dc23798e8cf3eddef834164eb637686cda"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/0d/cc/ff1904eb5eb4b455e442834dabf9427331ac0fa02853bf83db817a7dd53d/werkzeug-3.0.1.tar.gz"
    sha256 "507e811ecea72b18a404947aded4b3390e1db8f826b494d76550ef45bb3b1dcc"
  end

  resource "wsproto" do
    url "https://files.pythonhosted.org/packages/c9/4a/44d3c295350d776427904d73c189e10aeae66d7f555bb2feee16d1e4ba5a/wsproto-1.2.0.tar.gz"
    sha256 "ad565f26ecb92588a3e43bc3d96164de84cd9902482b130d0ddbaa9664a85065"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/4d/70/1f883646641d7ad3944181549949d146fa19e286e892bc013f7ce1579e8f/zstandard-0.21.0.tar.gz"
    sha256 "f08e3a10d01a247877e4cb61a82a319ea746c356a3786558bed2481e6c405546"
  end

  def install
    ENV["PROTOC"] = Formula["protobuf"].opt_bin/"protoc"

    virtualenv_install_with_resources
  end

  test do
    ENV["LANG"] = "en_US.UTF-8"
    assert_match version.to_s, shell_output("#{bin}/mitmproxy --version 2>&1")
  end
end

__END__
--- a/local_dependencies/mitmproxy/build.rs
+++ b/local_dependencies/mitmproxy/build.rs
@@ -1,9 +1,11 @@
 extern crate prost_build;

 fn main() {
-    if let Ok(protoc_path) = protoc_bin_vendored::protoc_bin_path() {
-        std::env::set_var("PROTOC", protoc_path);
-    }
+    let protoc_path = match std::env::var("PROTOC") {
+        Ok(path) if !path.is_empty() => std::path::PathBuf::from(path),
+        _ => protoc_bin_vendored::protoc_bin_path().expect("protoc is not available"),
+    };
+    std::env::set_var("PROTOC", protoc_path);

     prost_build::compile_protos(
         &["./src/packet_sources/ipc.proto"],