class Step < Formula
  desc "Crypto and x509 Swiss-Army-Knife"
  homepage "https:smallstep.com"
  url "https:github.comsmallstepclireleasesdownloadv0.25.1step_0.25.1.tar.gz"
  sha256 "8ad88e367ef0c4403a223f241fbf81fab288549a491d34e072ea8cfc94f93a76"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "540647062be19b0f19708a560c39aa025bd29d764b04a14804c5be2131e4454f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1d82ee512b5e50fb2609a0589bb0bbc59e463ce4bef3b25d43b0337d9adb66f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e72f4f5cb3d13d23192af654360503f85e50ea455ab2d95c9baca5fab39a884f"
    sha256 cellar: :any_skip_relocation, sonoma:         "eba37274fe6cc8ed8b634d22664a2f28534c1cdf544ed6c7fabc01e73e8de1a8"
    sha256 cellar: :any_skip_relocation, ventura:        "81f7a09237d5f57349f70894bdf8194b2c46d56893026feecac0c99703227f6b"
    sha256 cellar: :any_skip_relocation, monterey:       "cfb9d09c93b76298dd5fa9e718da96555fd61c579d17a1f85e970ef524d01164"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1712e20e16fccf880bf14df07e3a30e9e02e69f533475d9ff5ba56361e3b2442"
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