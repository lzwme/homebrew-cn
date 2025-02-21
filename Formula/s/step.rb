class Step < Formula
  desc "Crypto and x509 Swiss-Army-Knife"
  homepage "https:smallstep.com"
  url "https:github.comsmallstepclireleasesdownloadv0.28.3step_0.28.3.tar.gz"
  sha256 "320d321081d4df326a5d4b376652533f548fd3da8b99fd97f9db17eb03504fd9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51b4e317228e1db8311e01e72ae7acd012541b0a1069fd5eabbc0fd6c1e90854"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d4a30085a3c653de59782262130432e81ca4c6fc208d45ed882375bdf1c0647"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "747009a46278a4168be51bb52cc12505a380fc391ed5fc90fe6c4a05057bcb4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "deb0ba06ff5e82f58b60d6e1358229c6ff488e1563dd08d6050722b6f1bfc329"
    sha256 cellar: :any_skip_relocation, ventura:       "7335ad12f71140734d51703a4880847c178812876b1fa4b34c64ac76b277fc4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "402b5ef0381d4c4a155fd1eb5188adaea7c1feb5fbbe1264147582dc3a914a63"
  end

  depends_on "go" => :build

  # certificates is not always in sync with step, see discussions in https:github.comsmallstepcertificatesissues1925
  resource "certificates" do
    url "https:github.comsmallstepcertificatesreleasesdownloadv0.28.1step-ca_0.28.1.tar.gz"
    sha256 "932f4eac08071f1290da62834b0d665839c7b31b87f168d747fead42a6984d30"
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
    assert_path_exists testpath"foo.pub"
    assert_path_exists testpath"foo.priv"

    # Generate a root certificate and private key with subject baz written to baz.crt and baz.key.
    system bin"step", "certificate", "create", "--profile", "root-ca",
        "--no-password", "--insecure", "baz", "baz.crt", "baz.key"
    assert_path_exists testpath"baz.crt"
    assert_path_exists testpath"baz.key"
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
    assert_path_exists testpath"zap.crt"
    assert_path_exists testpath"zap.key"
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

      sleep 6
      shell_output("#{bin}step ca health > health_response.txt")
      assert_match(^ok$, File.read(testpath"health_response.txt"))

      shell_output("#{bin}step ca token --password-file #{testpath}password.txt " \
                   "homebrew-smallstep-leaf > token.txt")
      token = File.read(testpath"token.txt")
      system bin"step", "ca", "certificate", "--token", token,
          "homebrew-smallstep-leaf", "brew.crt", "brew.key"

      assert_path_exists testpath"brew.crt"
      assert_path_exists testpath"brew.key"
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