class Onionprobe < Formula
  include Language::Python::Virtualenv

  desc "Test and monitoring tool for Tor Onion Services"
  homepage "https://tpo.pages.torproject.net/onion-services/onionprobe/"
  url "https://files.pythonhosted.org/packages/30/d0/6441b228ce174481ace50dec6a19ce6298eebdb35d06f40f7b1de66f51c4/onionprobe-1.4.1.tar.gz"
  sha256 "45c12c89829e344422974aa9d56cc653d1e20a2f225e73ee18aeb995ca47a2be"
  license "GPL-3.0-or-later"
  revision 5
  head "https://gitlab.torproject.org/tpo/onion-services/onionprobe.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d13f71b1b6c1adf8476f32e6458bbad927f5edbb4b35a6ce722829741c5e25ac"
    sha256 cellar: :any, arm64_tahoe:       "8d022f23593f09bac7e28f65addf9814881379f1846b390df73d55099ac8ecd7"
    sha256 cellar: :any, arm64_sequoia:     "557a07273160caa90e01841011f12f6311d0b38aaf43656b28412667461c1b9e"
    sha256 cellar: :any, arm64_linux:       "5a158b75a0c8f6a7a6ca1ec2214e5439cf7999dd62ec0d6fcea3c9ae807fc73a"
    sha256 cellar: :any, x86_64_linux:      "638165cf24ca84720f4ef65d91d4d98c41c4671a97ee2003013c61dc5b38801c"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "tor"

  pypi_packages exclude_packages: %w[certifi cryptography]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "prometheus-client" do
    url "https://files.pythonhosted.org/packages/52/73/f1334c29c2af4cd9dba6c7817e61b611bd0215e2eb5565c6064a4de18802/prometheus_client-0.26.0.tar.gz"
    sha256 "04a91bcf94e2cf74a44a1a874d651a2e853ed354b6e822f3b7487751465d5c2b"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "stem" do
    url "https://files.pythonhosted.org/packages/94/c6/b2258155546f966744e78b9862f62bd2b8671b422bb9951a1330e4c8fd73/stem-1.8.2.tar.gz"
    sha256 "83fb19ffd4c9f82207c006051480389f80af221a7e4783000aedec4e384eb582"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  # TODO: Remove when descriptor retries preserve successful results, https://gitlab.torproject.org/tpo/onion-services/onionprobe/-/issues/117
  patch :DATA

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/onionprobe --version")

    output = shell_output("#{bin}/onionprobe -e 2gzyxa5ihm7nsggfxnu52rck2vv4rvmdlkiu3zzui5du4xyclen53wid.onion 2>&1")
    assert_match "Status code is 200", output
  end
end

__END__
--- a/packages/onionprobe/descriptor.py
+++ b/packages/onionprobe/descriptor.py
@@ -253,8 +253,8 @@
             self.set_metric('onion_service_descriptor_fetch_attempts',
                             attempt, labels)

-            # Return the inner layer or False
-            return inner
+        # Return the inner layer or False
+        return inner

     def hsdesc_event(
             self,