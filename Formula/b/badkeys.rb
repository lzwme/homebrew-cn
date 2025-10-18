class Badkeys < Formula
  include Language::Python::Virtualenv

  desc "Tool to find common vulnerabilities in cryptographic public keys"
  homepage "https://badkeys.info"
  url "https://files.pythonhosted.org/packages/55/db/bc7583f7f0ed8effe33c20c0f4190b7167ae25a81641d8670a9e3ecb7adc/badkeys-0.0.14.tar.gz"
  sha256 "5eec8c646e90e1f8f64115ee9ea120d6886a231aae7d619017506f8cc630f48d"
  license "MIT"
  head "https://github.com/badkeys/badkeys.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "9806b5e535be6712262a43feb4ebad23615bf12bc632df45dce500f555882a1e"
    sha256 cellar: :any,                 arm64_sequoia: "39dfa6f5a1988016755b1bd5a07b58114190a5ff2867de0c702c22d9102be87d"
    sha256 cellar: :any,                 arm64_sonoma:  "5d5496ecc3f90a28df364be7643446a5281228fc009e0ef090588221e89e040f"
    sha256 cellar: :any,                 sonoma:        "1a70e69b84522bac473855776f8b8362b8578128330ddac987f09ae593374cc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1302b0437d907419f57f5164792750ebc2245ac373672803d9da9dd136532a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bd97a3fd9c0cb48b4e9d2079f98d715b386a5688fd1455e7db2e8e9a4a5178d"
  end

  depends_on "cryptography"
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "python@3.14"

  resource "gmpy2" do
    url "https://files.pythonhosted.org/packages/07/bd/c6c154ce734a3e6187871b323297d8e5f3bdf9feaafc5212381538bc19e4/gmpy2-2.2.1.tar.gz"
    sha256 "e83e07567441b78cb87544910cb3cc4fe94e7da987e93ef7622e76fb96650432"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/badkeys --update-bl")
    assert_match "Writing new badkeysdata.json...", output

    # taken from https://ghfast.top/https://raw.githubusercontent.com/badkeys/badkeys/main/tests/data/rsa-debianweak.key
    (testpath/"rsa-debianweak.key").write <<~EOS
      -----BEGIN RSA PUBLIC KEY-----
      MIIBCgKCAQEAwJZTDExKND/DiP+LbhTIi2F0hZZt0PdX897LLwPf3+b1GOCUj1OH
      BZvVqhJPJtOPE53W68I0NgVhaJdY6bFOA/cUUIFnN0y/ZOJOJsPNle1aXQTjxAS+
      FXu4CQ6a2pzcU+9+gGwed7XxAkIVCiTprfmRCI2vIKdb61S8kf5D3YdVRH/Tq977
      nxyYeosEGYJFBOIT+N0mqca37S8hA9hCJyD3p0AM40dD5M5ARAxpAT7+oqOXkPzf
      zLtCTaHYJK3+WAce121Br4NuQJPqYPVxniUPohT4YxFTqB7vwX2C4/gZ2ldpHtlg
      JVAHT96nOsnlz+EPa5GtwxtALD43CwOlWQIDAQAB
      -----END RSA PUBLIC KEY-----
    EOS

    output = shell_output("#{bin}/badkeys #{testpath}/rsa-debianweak.key")
    assert_match "blocklist/debianssl vulnerability, rsa[2048], #{testpath}/rsa-debianweak.key", output
  end
end