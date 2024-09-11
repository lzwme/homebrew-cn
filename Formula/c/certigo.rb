class Certigo < Formula
  desc "Utility to examine and validate certificates in a variety of formats"
  homepage "https:github.comsquarecertigo"
  url "https:github.comsquarecertigoarchiverefstagsv1.16.0.tar.gz"
  sha256 "a6ce89964ca2fbe7d45d2e2019b06a21984f133c4f1f110eee12a67dd60c4145"
  license "Apache-2.0"
  head "https:github.comsquarecertigo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bedd60c233d5c81a9a6b79cd90d02570948d21d65e81bfbf356a0d49d4767467"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b5b86dcb9c261113bc75c507822f26c1774ee29a16886471ffc72121218ff20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7030162d50a9cc7a151ef7e5bb30c6ec6de9717c5ed71c56fc207548334142a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a663a86882876335dfd364332494270957a0b6778975aa0f9e8ba2fd83f8aa52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c632fa6622d2cd6f5899c3f1682f6646803e9d33efb56b4bc39417d09b55a72"
    sha256 cellar: :any_skip_relocation, sonoma:         "99c723ecb99e039fbf7c3146e5c19a9271a405c76f2b8d7d00868e1dc0d79677"
    sha256 cellar: :any_skip_relocation, ventura:        "30402885e7dd0a6a968f324ad7da21682b494977c18f8d0ee8ae10fe3b8c471d"
    sha256 cellar: :any_skip_relocation, monterey:       "f923b26c0f5b4115434a770994e0c791d192a482121840bf82323ae14b1627d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "a69ecd639ae8ae13f627bfb182a1fc29467b6ca58b917863d5d01d09731f98ff"
    sha256 cellar: :any_skip_relocation, catalina:       "e3f412c147bc0a3b42167d3b0c349b4d6bd175bb4a89fe4603cb68400630c471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10522c5a7fcd8524a1a0ce6755c2ffba1a6e76e63249f77d24326400c9ddc243"
  end

  depends_on "go" => :build

  def install
    system ".build"
    bin.install "bincertigo"

    generate_completions_from_executable(bin"certigo", shell_parameter_format: "--completion-script-",
                                                        shells:                 [:bash, :zsh])
  end

  test do
    (testpath"test.crt").write <<~EOS
      -----BEGIN CERTIFICATE-----
      MIIDLDCCAhQCCQCa74bQsAj2jANBgkqhkiG9w0BAQsFADBYMQswCQYDVQQGEwJV
      UzELMAkGA1UECBMCQ0ExEDAOBgNVBAoTB2NlcnRpZ28xEDAOBgNVBAsTB2V4YW1w
      bGUxGDAWBgNVBAMTD2V4YW1wbGUtZXhwaXJlZDAeFw0xNjA2MTAyMjE0MTJaFw0x
      NjA2MTEyMjE0MTJaMFgxCzAJBgNVBAYTAlVTMQswCQYDVQQIEwJDQTEQMA4GA1UE
      ChMHY2VydGlnbzEQMA4GA1UECxMHZXhhbXBsZTEYMBYGA1UEAxMPZXhhbXBsZS1l
      eHBpcmVkMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAs6JY7HmNAsH
      3nuMOOSBno6WmwsTYEw3hk4eyprWiINpoiaiZVCGahT8NAKqLDW5t9vgKz6c4ff
      i5aQ2scichq3QS7pELAYlS4b+ey3dA6hj62MOTTO4Ad5bFbbRZG+Mdm2Ayvl6eV
      6catQhMvxt7aIoY9+bodyIYC1zZVqwQ5sOT+CPLDnxK+GvhoyD2jLXwZplWiIVL
      oX6eEpKIoQtB6mSU216FPuAzlBJond+RzF9mcxJjdZYZlhwT8+o8oXEMI4vEf
      3yzd+zBmjuxDJR2iw3bSL+zZr2GVCsMLGjmvbpIuyIp5eTy0alz+iHOiyeCN
      9pgD6jyonwIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQAMUuvzVYniJ94GdOVcNJ
      bL3CxR5lo6YB04S425qsVrmOex3IQBL1fUduKSSxh5nF+6nzhRzRrDzp07f9pWHL
      ZHt6rruVhE1Eqt7TKKCtZg0d85lmx5WddL+yWc5cI1UtCohB9+iZDPUBUR9RcszQ
      dGD9PmxnPc9soEcQw3iNffhMMpLRhPaRW9qtJU8wk16DZunWR8E0Oeq42jVTnb4
      ZiD1Idajj0tjrT5M1KZLEiOzXVpo+l+hoXw9eVnRa2nBwjoiZ9cMuGKUpHm
      YSv7SyFevNwDwcxcAq6uVitKi0YCqHiNZ7Ye3BGRDUFpK2IASUo8YbXYNyA6nu
      -----END CERTIFICATE-----
    EOS
    system bin"certigo", "dump", "test.crt"
  end
end