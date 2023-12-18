class Aerleon < Formula
  desc "Generate firewall configs for multiple firewall platforms"
  homepage "https:aerleon.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackagesb8e5f4386abc5d0e7f18bba22650514c1c14dbd235c93e11ac020f6c724614daaerleon-1.7.0.tar.gz"
  sha256 "f3145c2a04f37c0463fbd80ee650f039bda9bc445e9c7fd4f18d8eeeda1b6ead"
  license "Apache-2.0"
  head "https:github.comaerleonaerleon.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c1b65930b667fcfae99c5a424d9c8e3cd44f2571fb3c9e0385531f71496b631"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbd227303b41ec320a2eb4cd1d2c88f26d84c41dd7fd3c6ad161dbf2e90e3e5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35377a544fd125beed57aaedb5b4833889297dc163008e63847dec8e88f8d24a"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f70ece21ef37df4123de7301edba034c019da2258c711232ed5b8b663da47f7"
    sha256 cellar: :any_skip_relocation, ventura:        "f2a1cd2c3cd15b25e685f83e606a36369a9999dd1d802f9a40ef3114a9074d49"
    sha256 cellar: :any_skip_relocation, monterey:       "471d3f6860c4f2dd3bc5b6cce5ff3a4100074b3d0595067899fef80fac5bbe59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df1f0b57a62fb6c0dce4bb584fab002dd7afc9cb25b884a41bf89ace6336884c"
  end

  depends_on "poetry" => :build
  depends_on "python-setuptools" => :build
  depends_on "python-abseil"
  depends_on "python-ply"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"

  def python3
    "python3.12"
  end

  def install
    site_packages = Language::Python.site_packages(python3)
    ENV.prepend_path "PYTHONPATH", Formula["poetry"].opt_libexecsite_packages

    system python3, "-m", "pip", "install", *std_pip_args, "."
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