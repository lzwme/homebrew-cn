class Step < Formula
  desc "Crypto and x509 Swiss-Army-Knife"
  homepage "https://smallstep.com"
  url "https://ghproxy.com/https://github.com/smallstep/cli/releases/download/v0.24.4/step_0.24.4.tar.gz"
  sha256 "0dcbbd7cbdfe8a4284171a1cea9e5b4a5f476949b472039159cb4583f3e31e88"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd31c5ad1b4135517e58efa989d8b94d5db573f90446df826c38da1f601c37c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a853e53440a45f76b3bb8b10c653db524b087585837726557116c3373550e39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0516c8375978cd0605555358eddfee28219bea73306995161385702b3126091"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94f12cccbb58366b8d53541632d74450fbc996f03a5586a26a095e5be7b37c9d"
    sha256 cellar: :any_skip_relocation, sonoma:         "56687c94998e3c1d4d68c6ebea7f8a84e8ed8b8d7d27d0333a162044eb11392c"
    sha256 cellar: :any_skip_relocation, ventura:        "73ae05755cf1f430f28a0f4deee0df734ba814e8ca3ad8b414e208041c91c9a7"
    sha256 cellar: :any_skip_relocation, monterey:       "c98e0ab63cbc2164f593fed6da5d4ff56510bd4060ddb57cbca71a48a63544bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfa23eb0af13bbc3fb9bc079b0312505e7a6a1cdee083915e17e51a82522d737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d353ade2fbfc195fe7920efae5658153440a960be62430d12506d12429503b15"
  end

  depends_on "go" => :build

  resource "certificates" do
    url "https://ghproxy.com/https://github.com/smallstep/certificates/releases/download/v0.24.2/step-ca_0.24.2.tar.gz"
    sha256 "896715f958aa61c1075d39d5ae957198305ba7d94a49d2c737b21155d5edb631"
  end

  def install
    ENV["VERSION"] = version.to_s
    ENV["CGO_OVERRIDE"] = "CGO_ENABLED=1"
    system "make", "build"
    bin.install "bin/step" => "step"
    bash_completion.install "autocomplete/bash_autocomplete" => "step"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_step"

    resource("certificates").stage do |r|
      ENV["VERSION"] = r.version.to_s
      ENV["CGO_OVERRIDE"] = "CGO_ENABLED=1"
      system "make", "build"
      bin.install "bin/step-ca" => "step-ca"
    end
  end

  test do
    # Generate a public / private key pair. Creates foo.pub and foo.priv.
    system "#{bin}/step", "crypto", "keypair", "foo.pub", "foo.priv", "--no-password", "--insecure"
    assert_predicate testpath/"foo.pub", :exist?
    assert_predicate testpath/"foo.priv", :exist?

    # Generate a root certificate and private key with subject baz written to baz.crt and baz.key.
    system "#{bin}/step", "certificate", "create", "--profile", "root-ca",
        "--no-password", "--insecure", "baz", "baz.crt", "baz.key"
    assert_predicate testpath/"baz.crt", :exist?
    assert_predicate testpath/"baz.key", :exist?
    baz_crt = File.read(testpath/"baz.crt")
    assert_match(/^-----BEGIN CERTIFICATE-----.*/, baz_crt)
    assert_match(/.*-----END CERTIFICATE-----$/, baz_crt)
    baz_key = File.read(testpath/"baz.key")
    assert_match(/^-----BEGIN EC PRIVATE KEY-----.*/, baz_key)
    assert_match(/.*-----END EC PRIVATE KEY-----$/, baz_key)
    shell_output("#{bin}/step certificate inspect --format json baz.crt > baz_crt.json")
    baz_crt_json = JSON.parse(File.read(testpath/"baz_crt.json"))
    assert_equal "CN=baz", baz_crt_json["subject_dn"]
    assert_equal "CN=baz", baz_crt_json["issuer_dn"]

    # Generate a leaf certificate signed by the previously created root.
    system "#{bin}/step", "certificate", "create", "--profile", "intermediate-ca",
        "--no-password", "--insecure", "--ca", "baz.crt", "--ca-key", "baz.key",
        "zap", "zap.crt", "zap.key"
    assert_predicate testpath/"zap.crt", :exist?
    assert_predicate testpath/"zap.key", :exist?
    zap_crt = File.read(testpath/"zap.crt")
    assert_match(/^-----BEGIN CERTIFICATE-----.*/, zap_crt)
    assert_match(/.*-----END CERTIFICATE-----$/, zap_crt)
    zap_key = File.read(testpath/"zap.key")
    assert_match(/^-----BEGIN EC PRIVATE KEY-----.*/, zap_key)
    assert_match(/.*-----END EC PRIVATE KEY-----$/, zap_key)
    shell_output("#{bin}/step certificate inspect --format json zap.crt > zap_crt.json")
    zap_crt_json = JSON.parse(File.read(testpath/"zap_crt.json"))
    assert_equal "CN=zap", zap_crt_json["subject_dn"]
    assert_equal "CN=baz", zap_crt_json["issuer_dn"]

    # Initialize a PKI and step-ca configuration, boot the CA, and create a
    # certificate using the API.
    (testpath/"password.txt").write("password")
    steppath = "#{testpath}/.step"
    mkdir_p(steppath)
    ENV["STEPPATH"] = steppath
    system "#{bin}/step", "ca", "init", "--address", "127.0.0.1:8081",
        "--dns", "127.0.0.1", "--password-file", "#{testpath}/password.txt",
        "--provisioner-password-file", "#{testpath}/password.txt", "--name",
        "homebrew-smallstep-test", "--provisioner", "brew"

    begin
      pid = fork do
        exec "#{bin}/step-ca", "--password-file", "#{testpath}/password.txt",
          "#{steppath}/config/ca.json"
      end

      sleep 2
      shell_output("#{bin}/step ca health > health_response.txt")
      assert_match(/^ok$/, File.read(testpath/"health_response.txt"))

      shell_output("#{bin}/step ca token --password-file #{testpath}/password.txt " \
                   "homebrew-smallstep-leaf > token.txt")
      token = File.read(testpath/"token.txt")
      system "#{bin}/step", "ca", "certificate", "--token", token,
          "homebrew-smallstep-leaf", "brew.crt", "brew.key"

      assert_predicate testpath/"brew.crt", :exist?
      assert_predicate testpath/"brew.key", :exist?
      brew_crt = File.read(testpath/"brew.crt")
      assert_match(/^-----BEGIN CERTIFICATE-----.*/, brew_crt)
      assert_match(/.*-----END CERTIFICATE-----$/, brew_crt)
      brew_key = File.read(testpath/"brew.key")
      assert_match(/^-----BEGIN EC PRIVATE KEY-----.*/, brew_key)
      assert_match(/.*-----END EC PRIVATE KEY-----$/, brew_key)
      shell_output("#{bin}/step certificate inspect --format json brew.crt > brew_crt.json")
      brew_crt_json = JSON.parse(File.read(testpath/"brew_crt.json"))
      assert_equal "CN=homebrew-smallstep-leaf", brew_crt_json["subject_dn"]
      assert_equal "O=homebrew-smallstep-test, CN=homebrew-smallstep-test Intermediate CA", brew_crt_json["issuer_dn"]
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end
  end
end