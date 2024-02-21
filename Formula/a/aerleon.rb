class Aerleon < Formula
  include Language::Python::Virtualenv

  desc "Generate firewall configs for multiple firewall platforms"
  homepage "https:aerleon.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackagesb8e5f4386abc5d0e7f18bba22650514c1c14dbd235c93e11ac020f6c724614daaerleon-1.7.0.tar.gz"
  sha256 "f3145c2a04f37c0463fbd80ee650f039bda9bc445e9c7fd4f18d8eeeda1b6ead"
  license "Apache-2.0"
  revision 1
  head "https:github.comaerleonaerleon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c61f872f3a69078ebd387bc4cd8a0c274be637a735cae556c54624637fb5ce1a"
    sha256 cellar: :any,                 arm64_ventura:  "c9c9a73139771a0de0174ffc0678241ab7ae8a30b14f34b4d1e2488478b2b0cb"
    sha256 cellar: :any,                 arm64_monterey: "7dbe36296a72efecccebdff1ab38f168e7d2e95f429496754307898ff780545f"
    sha256 cellar: :any,                 sonoma:         "1a51907483f5f3adab0715f3e8d5cebbf4c7325f97ded9dccff0d99aaf19f0f1"
    sha256 cellar: :any,                 ventura:        "227e3d0bc22e7c43bac00bbb2d0d615bf65b337d9e69e27f2ff987cbd2e401f4"
    sha256 cellar: :any,                 monterey:       "f2133443e9720c6965d008e6426355dd03e4330719c85c2a8ae1834d1d0e9f2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f36f0dc1b5f5aa8a87cda60453db6f81eaced8fed9d9575f114bb0546165bf1"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "absl-py" do
    url "https:files.pythonhosted.orgpackages79c945ecff8055b0ce2ad2bfbf1f438b5b8605873704d50610eda05771b865a0absl-py-1.4.0.tar.gz"
    sha256 "d2c244d01048ba476e7c080bd2c6df5e141d211de80223460d5b3b8a2a58433d"
  end

  resource "ply" do
    url "https:files.pythonhosted.orgpackagese569882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4daply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackages0c1deb26f5e75100d531d7399ae800814b069bc2ed2a7410834d57374d010d96typing_extensions-4.9.0.tar.gz"
    sha256 "23478f88c37f27d76ac8aee6c905017a143b0b1b886c3c9f66bc2fd94f9f5783"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"defdefinitions.yaml").write <<~EOS
      networks:
        RFC1918:
          values:
            - address: 10.0.0.08
            - address: 172.16.0.012
            - address: 192.168.0.016
        WEB_SERVERS:
          values:
            - address: 10.0.0.132
              comment: Web Server 1
            - address: 10.0.0.232
              comment: Web Server 2
        MAIL_SERVERS:
          values:
            - address: 10.0.0.332
              comment: Mail Server 1
            - address: 10.0.0.432
              comment: Mail Server 2
        ALL_SERVERS:
          values:
            - WEB_SERVERS
            - MAIL_SERVERS
      services:
        HTTP:
          - protocol: tcp
            port: 80
        HTTPS:
          - protocol: tcp
            port: 443
        WEB:
          - HTTP
          - HTTPS
        HIGH_PORTS:
          - port: 1024-65535
            protocol: tcp
          - port: 1024-65535
            protocol: udp
    EOS

    (testpath"policiespolexample.pol.yaml").write <<~EOS
      filters:
      - header:
          comment: Example inbound
          targets:
            cisco: inbound extended
        terms:
          - name: accept-web-servers
            comment: Accept connections to our web servers.
            destination-address: WEB_SERVERS
            destination-port: WEB
            protocol: tcp
            action: accept
          - name: default-deny
            comment: Deny anything else.
            action: deny#{"  "}
    EOS

    assert_match "writing file: example.pol.acl", shell_output("#{bin}aclgen 2>&1")
    assert_path_exists "example.pol.acl"
  end
end