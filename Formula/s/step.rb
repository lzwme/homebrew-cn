class Step < Formula
  desc "Crypto and x509 Swiss-Army-Knife"
  homepage "https:smallstep.com"
  url "https:github.comsmallstepclireleasesdownloadv0.27.5step_0.27.5.tar.gz"
  sha256 "b2e5e3c4bf2ed0b99a65bea649b66032ced94388cc08af569ee53ff299a14e18"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "001623d26b11678b3909b69c556b44bca86ff1814b251edb087e864e22bddc06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eafcff5ba922636b81f3c3c74f79a547482ef130a0ed02b67624c69a3761e419"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "153012d6ae22e193add33e2984c0e4833c922c3a61e6ee144ce8e37d9e80fb71"
    sha256 cellar: :any_skip_relocation, sonoma:        "ade247b235cde3593c556a279648f034346f997fecea3c7d3f160fabb5d24061"
    sha256 cellar: :any_skip_relocation, ventura:       "31098b478a6813ac0187b002677c5210f27a42ef64f1374042217409247885bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "324bec6e8eae955df91cb90cdac66a5829d490a0043569fd0bb836af7385f965"
  end

  depends_on "go" => :build

  # certificates is not always in sync with step, see discussions in https:github.comsmallstepcertificatesissues1925
  resource "certificates" do
    url "https:github.comsmallstepcertificatesreleasesdownloadv0.27.4step-ca_0.27.4.tar.gz"
    sha256 "6ac5ba0c183c87c6039c052de1d79082ac5df474d90ce026121607302f06ce6d"
  end

  def install
    ENV["VERSION"] = version.to_s
    ENV["CGO_OVERRIDE"] = "CGO_ENABLED=1"
    system "make", "build"
    bin.install "binstep" => "step"
    generate_completions_from_executable(bin"step", "completion")

    resource("certificates").stage do |r|
      ENV["VERSION"] = r.version.to_s
      ENV["CGO_OVERRIDE"] = "CGO_ENABLED=1"
      system "make", "build"
      bin.install "binstep-ca" => "step-ca"
    end
  end

  test do
    # Generate a public  private key pair. Creates foo.pub and foo.priv.
    system bin"step", "crypto", "keypair", "foo.pub", "foo.priv", "--no-password", "--insecure"
    assert_predicate testpath"foo.pub", :exist?
    assert_predicate testpath"foo.priv", :exist?

    # Generate a root certificate and private key with subject baz written to baz.crt and baz.key.
    system bin"step", "certificate", "create", "--profile", "root-ca",
        "--no-password", "--insecure", "baz", "baz.crt", "baz.key"
    assert_predicate testpath"baz.crt", :exist?
    assert_predicate testpath"baz.key", :exist?
    baz_crt = File.read(testpath"baz.crt")
    assert_match(^-----BEGIN CERTIFICATE-----.*, baz_crt)
    assert_match(.*-----END CERTIFICATE-----$, baz_crt)
    baz_key = File.read(testpath"baz.key")
    assert_match(^-----BEGIN EC PRIVATE KEY-----.*, baz_key)
    assert_match(.*-----END EC PRIVATE KEY-----$, baz_key)
    shell_output("#{bin}step certificate inspect --format json baz.crt > baz_crt.json")
    baz_crt_json = JSON.parse(File.read(testpath"baz_crt.json"))
    assert_equal "CN=baz", baz_crt_json["subject_dn"]
    assert_equal "CN=baz", baz_crt_json["issuer_dn"]

    # Generate a leaf certificate signed by the previously created root.
    system bin"step", "certificate", "create", "--profile", "intermediate-ca",
        "--no-password", "--insecure", "--ca", "baz.crt", "--ca-key", "baz.key",
        "zap", "zap.crt", "zap.key"
    assert_predicate testpath"zap.crt", :exist?
    assert_predicate testpath"zap.key", :exist?
    zap_crt = File.read(testpath"zap.crt")
    assert_match(^-----BEGIN CERTIFICATE-----.*, zap_crt)
    assert_match(.*-----END CERTIFICATE-----$, zap_crt)
    zap_key = File.read(testpath"zap.key")
    assert_match(^-----BEGIN EC PRIVATE KEY-----.*, zap_key)
    assert_match(.*-----END EC PRIVATE KEY-----$, zap_key)
    shell_output("#{bin}step certificate inspect --format json zap.crt > zap_crt.json")
    zap_crt_json = JSON.parse(File.read(testpath"zap_crt.json"))
    assert_equal "CN=zap", zap_crt_json["subject_dn"]
    assert_equal "CN=baz", zap_crt_json["issuer_dn"]

    # Initialize a PKI and step-ca configuration, boot the CA, and create a
    # certificate using the API.
    (testpath"password.txt").write("password")
    steppath = "#{testpath}.step"
    mkdir_p(steppath)
    ENV["STEPPATH"] = steppath
    system bin"step", "ca", "init", "--address", "127.0.0.1:8081",
        "--dns", "127.0.0.1", "--password-file", "#{testpath}password.txt",
        "--provisioner-password-file", "#{testpath}password.txt", "--name",
        "homebrew-smallstep-test", "--provisioner", "brew"

    begin
      pid = fork do
        exec bin"step-ca", "--password-file", "#{testpath}password.txt",
          "#{steppath}configca.json"
      end

      sleep 2
      shell_output("#{bin}step ca health > health_response.txt")
      assert_match(^ok$, File.read(testpath"health_response.txt"))

      shell_output("#{bin}step ca token --password-file #{testpath}password.txt " \
                   "homebrew-smallstep-leaf > token.txt")
      token = File.read(testpath"token.txt")
      system bin"step", "ca", "certificate", "--token", token,
          "homebrew-smallstep-leaf", "brew.crt", "brew.key"

      assert_predicate testpath"brew.crt", :exist?
      assert_predicate testpath"brew.key", :exist?
      brew_crt = File.read(testpath"brew.crt")
      assert_match(^-----BEGIN CERTIFICATE-----.*, brew_crt)
      assert_match(.*-----END CERTIFICATE-----$, brew_crt)
      brew_key = File.read(testpath"brew.key")
      assert_match(^-----BEGIN EC PRIVATE KEY-----.*, brew_key)
      assert_match(.*-----END EC PRIVATE KEY-----$, brew_key)
      shell_output("#{bin}step certificate inspect --format json brew.crt > brew_crt.json")
      brew_crt_json = JSON.parse(File.read(testpath"brew_crt.json"))
      assert_equal "CN=homebrew-smallstep-leaf", brew_crt_json["subject_dn"]
      assert_equal "O=homebrew-smallstep-test, CN=homebrew-smallstep-test Intermediate CA", brew_crt_json["issuer_dn"]
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end
  end
end