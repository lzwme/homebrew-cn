class Step < Formula
  desc "Crypto and x509 Swiss-Army-Knife"
  homepage "https:smallstep.com"
  url "https:github.comsmallstepclireleasesdownloadv0.25.2step_0.25.2.tar.gz"
  sha256 "325b34188476530a9bf14dabfe9545bc618674e4017bb888f2f7bec325b00f1b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd9e7970f966323ea140153dc32428ba80b032804e3f284bae1b7c85778d7615"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52c3ddc7455675cbaa810e8577923753f77fb493b993c4cd60150bc7b0de06c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cbbde9f2a5ee874768bd8f006704736c7db266feba0c3cd26a51f5fd102b0fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "db967b4a6df39631fabe334ec06a71d9a8bae49fb48555c4c0af5f3ba1160365"
    sha256 cellar: :any_skip_relocation, ventura:        "5eac5a0771d52b4197e2cc0a8b5fad8c33f9a795b953db6382c05f92eeaf487f"
    sha256 cellar: :any_skip_relocation, monterey:       "73900a65407f27396889a6f6891c25f63eaf50c5e0330fee0e922d80baf65ef8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b915c69ebc000e544e6f817b706fb3f031ba0d01cc3f0b16a779bcd6b2306674"
  end

  depends_on "go" => :build

  resource "certificates" do
    url "https:github.comsmallstepcertificatesreleasesdownloadv0.25.2step-ca_0.25.2.tar.gz"
    sha256 "c80ad05d959897592c3a5a014adf25cbfecdcb63abf67110436b04dd6789fdd3"
  end

  def install
    ENV["VERSION"] = version.to_s
    ENV["CGO_OVERRIDE"] = "CGO_ENABLED=1"
    system "make", "build"
    bin.install "binstep" => "step"
    bash_completion.install "autocompletebash_autocomplete" => "step"
    zsh_completion.install "autocompletezsh_autocomplete" => "_step"

    resource("certificates").stage do |r|
      ENV["VERSION"] = r.version.to_s
      ENV["CGO_OVERRIDE"] = "CGO_ENABLED=1"
      system "make", "build"
      bin.install "binstep-ca" => "step-ca"
    end
  end

  test do
    # Generate a public  private key pair. Creates foo.pub and foo.priv.
    system "#{bin}step", "crypto", "keypair", "foo.pub", "foo.priv", "--no-password", "--insecure"
    assert_predicate testpath"foo.pub", :exist?
    assert_predicate testpath"foo.priv", :exist?

    # Generate a root certificate and private key with subject baz written to baz.crt and baz.key.
    system "#{bin}step", "certificate", "create", "--profile", "root-ca",
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
    system "#{bin}step", "certificate", "create", "--profile", "intermediate-ca",
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
    system "#{bin}step", "ca", "init", "--address", "127.0.0.1:8081",
        "--dns", "127.0.0.1", "--password-file", "#{testpath}password.txt",
        "--provisioner-password-file", "#{testpath}password.txt", "--name",
        "homebrew-smallstep-test", "--provisioner", "brew"

    begin
      pid = fork do
        exec "#{bin}step-ca", "--password-file", "#{testpath}password.txt",
          "#{steppath}configca.json"
      end

      sleep 2
      shell_output("#{bin}step ca health > health_response.txt")
      assert_match(^ok$, File.read(testpath"health_response.txt"))

      shell_output("#{bin}step ca token --password-file #{testpath}password.txt " \
                   "homebrew-smallstep-leaf > token.txt")
      token = File.read(testpath"token.txt")
      system "#{bin}step", "ca", "certificate", "--token", token,
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