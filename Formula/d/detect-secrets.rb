class DetectSecrets < Formula
  desc "Enterprise friendly way of detecting and preventing secrets in code"
  homepage "https:github.comYelpdetect-secrets"
  url "https:files.pythonhosted.orgpackagesf155292f9ce52bba7f3df0a9cde65dabf458d3aeec6a63bf737e5a5fa9fe6d31detect_secrets-1.4.0.tar.gz"
  sha256 "d56787e339758cef48c9ccd6692f7a094b9963c979c9813580b0169e41132833"
  license "Apache-2.0"
  revision 3
  head "https:github.comYelpdetect-secrets.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b2886336122f0b9cf752cc8b4e52320364cb92f6bbc818e91b9fbf6d4b15bea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97e70483baccb342c9cb85271425849045e231e751991a6cd3887b442345acea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5138dd81e741f607d8e54ac3a5e21ea2533e68614e6287b547ab09dd0800b1c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "57721458f61a82edbd303efc33689c18cde547d37619228e9c72f517842b3f59"
    sha256 cellar: :any_skip_relocation, ventura:        "540ef50cc0e46002b8c71ac9713adab8360dc1918d59f027554a6c6d8fcb3641"
    sha256 cellar: :any_skip_relocation, monterey:       "148c565986159cb4f3c754def68989dc5b412b9bd294290a4cb1407d19169839"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21a3d5d84de53885607b4a4b19f9b5eccb9a906a82fb8a6f805ab0014a185a89"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-requests"
  depends_on "python@3.12"
  depends_on "pyyaml"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    assert_match "ArtifactoryDetector", shell_output("#{bin}detect-secrets scan --list-all-plugins 2>&1")
  end
end