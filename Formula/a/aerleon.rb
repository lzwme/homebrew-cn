class Aerleon < Formula
  include Language::Python::Virtualenv

  desc "Generate firewall configs for multiple firewall platforms"
  homepage "https://aerleon.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/32/fb/4c4c1efe07861f45fd6a06e67f9c5756663ff8c72fafda2ebaa7a71d0bd5/aerleon-1.18.0.tar.gz"
  sha256 "dcfcbefd62b39a6412912760b95360f5bd67239b4077f542c9095f36e419e341"
  license "Apache-2.0"
  head "https://github.com/aerleon/aerleon.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0d2037308d4419c13f94bdb460d4bceb1d69a4a872b3ed336da9b869a2e8c6ea"
    sha256 cellar: :any, arm64_tahoe:       "c753b5558528d1f6bec7745ff4c17ba00fd3c2daff2352d5878794a8c4781d0a"
    sha256 cellar: :any, arm64_sequoia:     "bf4451aa94e73ce9905c694a24260fdad4bd83881d8f0b0a433d6452d19cb11d"
    sha256 cellar: :any, arm64_linux:       "1d20d796f99c93e4c0b6afc4b3c7948429e9420374ed76a1aa9cb61c90f04890"
    sha256 cellar: :any, x86_64_linux:      "837b102617a35fcebbc7707c76c133181ea496b5ee95076934f283b0f9a16b3e"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  conflicts_with "cgrep", because: "both install `cgrep` binaries"

  resource "absl-py" do
    url "https://files.pythonhosted.org/packages/d0/4f/d79676ab82f2e42fc3611618139f13a9c4c31d0cff4b486982047679a802/absl_py-2.5.0.tar.gz"
    sha256 "0c996f25c0490700fadabe6351630f6111534fa0ae252cc6d2014ea3b141135f"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  # Although the virtualenv_install_with_resources uses the package resources listed above,
  # pip still needs to fetch the project's chosen build system via the network.
  deny_network_access! [:postinstall]

  def install
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