class Scour < Formula
  desc "SVG file scrubber"
  homepage "https:www.codedread.comscour"
  url "https:files.pythonhosted.orgpackages7519f519ef8aa2f379935a44212c5744e2b3a46173bf04e0110fb7f4af4028c9scour-0.38.2.tar.gz"
  sha256 "6881ec26660c130c5ecd996ac6f6b03939dd574198f50773f2508b81a68e0daf"
  license "Apache-2.0"
  revision 1
  version_scheme 1
  head "https:github.comscour-projectscour.git", branch: "master"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc5f5e857ec22d89871c1e33dc186015a8a76fb9afe1122a2eff34f99585d758"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3009abea4747222401235ca335cf412442850e50179259ba841639981973515a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "208bec3b0345834e4aad10b9cb1889e2bdd14e0aeb9bbeebbbab9bcd4d8dc6cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "9acb4f2ea41aa3969f12911f07d67b5e4e1e906e1a81c203f194d012faa2a99b"
    sha256 cellar: :any_skip_relocation, ventura:        "c3384fee26760a4ffb6eb2335025573be3d1b0d79632b6053326d020a6a2d12e"
    sha256 cellar: :any_skip_relocation, monterey:       "9bef809e6a0d173170b4c990742b8827eb6c2970601a8f9364824a8afa5d29a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc600b61a19b88d56999c0b025e8a25d5a7018c907a563124897c30a33e786a8"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.12"
  depends_on "six"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system "#{bin}scour", "-i", test_fixtures("test.svg"), "-o", "scrubbed.svg"
    assert_predicate testpath"scrubbed.svg", :exist?
  end
end