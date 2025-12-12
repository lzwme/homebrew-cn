class Aerleon < Formula
  include Language::Python::Virtualenv

  desc "Generate firewall configs for multiple firewall platforms"
  homepage "https://aerleon.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/07/f7/25b8ed9c98060d0aaf9280bcae867bd1a6189bf2306f6d2d7edb083cb798/aerleon-1.12.1.tar.gz"
  sha256 "78c94c8ac3e5c563e212b647420cb94e3ed5b72a860f5de0b927d2a5500dc82c"
  license "Apache-2.0"
  head "https://github.com/aerleon/aerleon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0cfab02376392b29109517151a8e1a23c3ad79ee8cd53466469afc9c1c0a7d39"
    sha256 cellar: :any,                 arm64_sequoia: "4de287892fb060f2250d1b6e63d98e380ec86bb671c649e3ceb0b804ce0fc279"
    sha256 cellar: :any,                 arm64_sonoma:  "5044574664f3ba214597b0a649b0612400b06ae4486707ce28d6d0ec650bb446"
    sha256 cellar: :any,                 sonoma:        "7885a12ec2320fd10ae943864df6f9f160ba1dd02dc20fd0f0380bcf3c96980e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5d9909b9b0f83cda9e8706945cb84004fa535e9256e5b009f99f36b85d12780"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "019db29d1a8cdad6503e655bce46034fc4160052c54f300d2c8e0961521e1a3a"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  conflicts_with "cgrep", because: "both install `cgrep` binaries"

  resource "absl-py" do
    url "https://files.pythonhosted.org/packages/10/2a/c93173ffa1b39c1d0395b7e842bbdc62e556ca9d8d3b5572926f3e4ca752/absl_py-2.3.1.tar.gz"
    sha256 "a97820526f7fbfd2ec1bce83f3f25e3a14840dac0d8e02a0b71cd75db3f77fc9"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
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