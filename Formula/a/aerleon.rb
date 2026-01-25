class Aerleon < Formula
  include Language::Python::Virtualenv

  desc "Generate firewall configs for multiple firewall platforms"
  homepage "https://aerleon.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/25/5f/eadcc4108b75efa18a9d48ed0164ea27d13c69fb3297004b6c0728e6b5ae/aerleon-1.14.1.tar.gz"
  sha256 "442306adaee42c0a28bef2202e116c2d1f7ae0473a0a34914bff63991617c244"
  license "Apache-2.0"
  head "https://github.com/aerleon/aerleon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "62d3f7c40b6b0031fe592217893917623bcf349602854fded3d60baf2b0f4444"
    sha256 cellar: :any,                 arm64_sequoia: "6d0530b071c64bdf754e2b8ea6d099a3fbe3f720544638b6acc20791a98fdb08"
    sha256 cellar: :any,                 arm64_sonoma:  "0c95dc28b42fd09869ae81a65cbfc67be5f22264e9fc53978c7ac8622e2db231"
    sha256 cellar: :any,                 sonoma:        "70c38da9ccb6be3ab6873d11b9379468c0c38ab5e2614ff9df394011821d8880"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d1d88d57942259243d9342c9c7482a84760ae6a9b525f4a86af65289e037715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61d56da5396d4450ec8f398030548532dc19b40d0a2813580cb6c2d684360193"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  conflicts_with "cgrep", because: "both install `cgrep` binaries"

  resource "absl-py" do
    url "https://files.pythonhosted.org/packages/10/2a/c93173ffa1b39c1d0395b7e842bbdc62e556ca9d8d3b5572926f3e4ca752/absl_py-2.3.1.tar.gz"
    sha256 "a97820526f7fbfd2ec1bce83f3f25e3a14840dac0d8e02a0b71cd75db3f77fc9"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  def install
    # hatch does not support a SOURCE_DATE_EPOCH before 1980.
    # Remove after https://github.com/pypa/hatch/pull/1999 is released.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"

    virtualenv_install_with_resources
  end

  test do
    (testpath/"def/definitions.yaml").write <<~YAML
      networks:
        RFC1918:
          values:
            - address: 10.0.0.0/8
            - address: 172.16.0.0/12
            - address: 192.168.0.0/16
        WEB_SERVERS:
          values:
            - address: 10.0.0.1/32
              comment: Web Server 1
            - address: 10.0.0.2/32
              comment: Web Server 2
        MAIL_SERVERS:
          values:
            - address: 10.0.0.3/32
              comment: Mail Server 1
            - address: 10.0.0.4/32
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
    YAML

    (testpath/"policies/pol/example.pol.yaml").write <<~YAML
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
    YAML

    assert_match "writing file: example.pol.acl", shell_output("#{bin}/aclgen 2>&1")
    assert_path_exists "example.pol.acl"
  end
end