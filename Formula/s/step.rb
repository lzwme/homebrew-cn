class Step < Formula
  desc "Crypto and x509 Swiss-Army-Knife"
  homepage "https:smallstep.com"
  url "https:github.comsmallstepclireleasesdownloadv0.26.0step_0.26.0.tar.gz"
  sha256 "128cebf24a3043ef1616be47d07c95f8a0d3432b626ff060c69eb1c806e98614"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ff61d321557000003f4afc6ed4296ee3d90cfd57817c5d2da6d5ffd3e742c15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9480994b2cca4c85ada87db10bc1bac173675a09a67dc28414f43b3d293bf885"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75baf0dc1138e43dae7adb32c630f1757149fb88a925e814be90243fc04bd1f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c9402289c2be7d22816b486c36bafcb331ed14a4930dc783a1fde98d1f78243"
    sha256 cellar: :any_skip_relocation, ventura:        "3014fe7f179163474bc4a2bfec445dfbaa784330fdec4a94dc9e3645f3298950"
    sha256 cellar: :any_skip_relocation, monterey:       "84fe05ba915be878926507f0cda022f124aeea440bf071690c12521390024c2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c8e14d8f13cb8a224101e748081d685b80419c9b3335ec8356931ccec65bd80"
  end

  depends_on "go" => :build

  resource "certificates" do
    url "https:github.comsmallstepcertificatesreleasesdownloadv0.26.0step-ca_0.26.0.tar.gz"
    sha256 "c49148c66b757a25002dfbf9bfa8b2346ded7973ec443dcdc31feb8d3bce582b"
  end

  def install
    odie "certificates resource needs to be updated" if version != resource("certificates").version

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