class CaCertificates < Formula
  desc "Mozilla CA certificate store"
  homepage "https://curl.se/docs/caextract.html"
  url "https://curl.se/ca/cacert-2024-07-02.pem"
  sha256 "1bf458412568e134a4514f5e170a328d11091e071c7110955c9884ed87972ac9"
  license "MPL-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?cacert[._-](\d{4}-\d{2}-\d{2})\.pem/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "efae38787c286c7a249f9e7158e3159107a361df5e68fc2a531ccb8177b01cbe"
  end

  def install
    pkgshare.install "cacert-#{version}.pem" => "cacert.pem"
  end

  def post_install
    if OS.mac?
      macos_post_install
    else
      linux_post_install
    end
  end

  def macos_post_install
    ohai "Regenerating CA certificate bundle from keychain, this may take a while..."

    keychains = %w[
      /Library/Keychains/System.keychain
      /System/Library/Keychains/SystemRootCertificates.keychain
    ]

    certs_list = Utils.safe_popen_read("/usr/bin/security", "find-certificate", "-a", "-p", *keychains)
    certs = certs_list.scan(
      /-----BEGIN CERTIFICATE-----.*?-----END CERTIFICATE-----/m,
    )

    # Check that the certificate has not expired
    valid_certs = certs.select do |cert|
      begin
        Utils.safe_popen_write("/usr/bin/openssl", "x509", "-inform", "pem",
                                                           "-checkend", "0",
                                                           "-noout") do |openssl_io|
          openssl_io.write(cert)
        end
      rescue ErrorDuringExecution
        # Expired likely.
        next
      end

      # Only include certs that have are designed to act as a SSL root.
      purpose = Utils.safe_popen_write("/usr/bin/openssl", "x509", "-inform", "pem",
                                                                   "-purpose",
                                                                   "-noout") do |openssl_io|
        openssl_io.write(cert)
      end
      purpose.include?("SSL server CA : Yes")
    end

    # Check that the certificate is trusted in keychain
    trusted_certs = begin
      tmpfile = Tempfile.new

      verify_args = %W[
        -l -L
        -c #{tmpfile.path}
        -p ssl
      ]
      on_high_sierra :or_newer do
        verify_args << "-R" << "offline"
      end

      valid_certs.select do |cert|
        tmpfile.rewind
        tmpfile.write cert
        tmpfile.truncate cert.size
        tmpfile.flush
        Utils.safe_popen_read("/usr/bin/security", "verify-cert", *verify_args)
        true
      rescue ErrorDuringExecution
        # Invalid.
        false
      end
    ensure
      tmpfile&.close!
    end

    # Get SHA256 fingerprints for all trusted certs
    fingerprints = trusted_certs.to_set do |cert|
      Utils.safe_popen_write("/usr/bin/openssl", "x509", "-inform", "pem",
                                                         "-fingerprint",
                                                         "-sha256",
                                                         "-noout") do |openssl_io|
        openssl_io.write(cert)
      end
    end

    # Now process Mozilla certs we downloaded.
    pem_certs_list = File.read(pkgshare/"cacert.pem")
    pem_certs = pem_certs_list.scan(
      /-----BEGIN CERTIFICATE-----.*?-----END CERTIFICATE-----/m,
    )

    # Append anything new.
    trusted_certs += pem_certs.select do |cert|
      fingerprint = Utils.safe_popen_write("/usr/bin/openssl", "x509", "-inform", "pem",
                                                                       "-fingerprint",
                                                                       "-sha256",
                                                                       "-noout") do |openssl_io|
        openssl_io.write(cert)
      end
      fingerprints.add?(fingerprint)
    end

    pkgetc.mkpath
    (pkgetc/"cert.pem").atomic_write(trusted_certs.join("\n") << "\n")
  end

  def linux_post_install
    rm(pkgetc/"cert.pem") if (pkgetc/"cert.pem").exist?
    pkgetc.mkpath
    cp pkgshare/"cacert.pem", pkgetc/"cert.pem"
  end

  test do
    assert_path_exists pkgshare/"cacert.pem"
    assert_path_exists pkgetc/"cert.pem"
    assert compare_file(pkgshare/"cacert.pem", pkgetc/"cert.pem") if OS.linux?
  end
end