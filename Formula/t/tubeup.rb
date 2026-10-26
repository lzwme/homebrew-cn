class Tubeup < Formula
  include Language::Python::Virtualenv

  desc "Use yt-dlp to download video/metadata and upload to the Internet Archive"
  homepage "https://github.com/bibanon/tubeup"
  url "https://files.pythonhosted.org/packages/7e/44/6deb75f6d3a553fe3f8dfbd7c0fdea15f31b67272808efad98303803cca7/tubeup-2026.5.8.tar.gz"
  sha256 "4c75423a429493bddaf78ede0031947938b3eb35435847ee6597b49a4be76ad7"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f3c97bb5ad286010905db69e9088cf8dbed7f788c7f450fcd84af86c197cb88c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "52ec32dde267a6b5b4d71e1fa7f237be9b863dc4be98fa49b2bd27cfbb73e7f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f110f568b590461c5d7235fcb9dcbe876d9e73ac52c6effa0553d9650419445e"
    sha256 cellar: :any,                 arm64_linux:       "93038067c961f273b19cc179bbbb4197b7d209406ede52c061bc736633a3f5e5"
    sha256 cellar: :any,                 x86_64_linux:      "331aa02cebf59bc76548740f29b5e1122ef228d516afc5c71a3f073097ab560e"
  end

  depends_on "node" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python@3.15"

  uses_from_macos "libffi"

  pypi_packages exclude_packages: %w[certifi cffi pycparser]

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/cf/81/1546c983678a9b4e77cb4718eaedd1b2caf24a6cdbf1eb8775938d22aff7/brotli-1.2.1.tar.gz"
    sha256 "02b2f7b5a83485efe448a44ddf7983def05c3bb1dcf917d4f7154070260e13de"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "curl-cffi" do
    url "https://files.pythonhosted.org/packages/82/e1/730125c43e3e331d98e17af3cb310ba526b3f1101b7635ca23d976ebfcf5/curl_cffi-0.16.3.tar.gz"
    sha256 "d15d0c2a35f2d75bec430c28946c2a833f421c85773bdb0795182cc5c515665b"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "internetarchive" do
    url "https://files.pythonhosted.org/packages/a5/e5/6299a3f04c085c9d3582840e2a086a3845e89b2ae5058fb817fca0a99795/internetarchive-5.12.1.tar.gz"
    sha256 "fa9589c463a8a64e1c194f19f40bac680e2db9b493a0d9722cf7d30754cde65b"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/8e/39/c534bb172e9318400d5631074b1eda6c78b7c918d0f04233b50caa8e2c10/jsonpatch-1.36.tar.gz"
    sha256 "7e110cb3c5a1c8768f7170bf8fb9887c4aa575fba74c95239e868b494bd9a522"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/52/77/9be5cce647fa4d7afa9047c0c1029bc73292c27430e64fc9d2393ccf6727/jsonpointer-3.4.tar.gz"
    sha256 "e57015ae65af3821c6a3976069860789cf326103f38b22b2178d41d021adad25"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/df/70/1675da133ea92227da41bf5b24e1c66be597ff736a1533ade41da986852f/mutagen-1.48.1.tar.gz"
    sha256 "8f95637ab9f6f305cec6bd1294e197debe207998e3e068596563c74f86b0a173"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/f4/e7/50e72301e32acb73a314e663c2014e1ddefc019d5f434ff14ec89861d664/pycryptodomex-3.24.1.tar.gz"
    sha256 "09081666ffc599976c0b8b29caf2cf82212c0f05bed233c8f8ed53e4f6e1d356"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/30/4b/4692be6d5bf739ed049b3813901c42091f8c054df89d5c089343823dea0d/websockets-17.3.tar.gz"
    sha256 "1c7dd93a1c9f89297471493674b1fc1d9467cafd45374f2172213046bdb3a329"
  end

  resource "yt-dlp" do
    url "https://files.pythonhosted.org/packages/06/13/d2ea252871826205dc4965cb70e6037ab93697fcabf4feda49fe981f6da0/yt_dlp-2026.10.21.tar.gz"
    sha256 "cbf748d7d17cd37647c4b9f07b6c25f24384bfd4361407ee5ec519e753d22539"
  end

  resource "yt-dlp-ejs" do
    url "https://files.pythonhosted.org/packages/d3/e6/cceb9530e8f4e5940f6f7822d90e9d94f1b85343329a16baaf47bbbb3de1/yt_dlp_ejs-0.8.0.tar.gz"
    sha256 "d5fa1639f63b5c4af8d932495f60689d5370f1a095782c944f7f62a303eb104e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Verify tubeup attempts to process a URL (expected failure for invalid video)
    output = shell_output("#{bin}/tubeup https://www.youtube.com/watch?v=invalid_video_id --dir #{testpath} 2>&1", 1)
    assert_match "ERROR: [youtube] invalid_vid:", output
  end
end