class MetaPackageManager < Formula
  include Language::Python::Virtualenv

  desc "Wrapper around all package managers with a unifying CLI"
  homepage "https://kdeldycke.github.io/meta-package-manager/"
  url "https://files.pythonhosted.org/packages/a0/94/b9dbfbf058f40ce3c64257806ae8ae76f377fc28f627b9b40777d26a742c/meta_package_manager-5.13.1.tar.gz"
  sha256 "364658a4c777725f6cccfe404c706ec514630eb15b5ac06a5a79cec6674b84ee"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eebe965515289d73ff235c791d2e84f714235bc9a04698d9fda91484811ee9fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20d171de528dc12d1c4c968b3ede2a787fb89d7fe8cc30289a7dabf65ad87817"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d656e725ddc6e487604db194a005ecc34635dd7d5ec0e9e8dfbba920b18e22fa"
    sha256 cellar: :any_skip_relocation, ventura:        "962d5c38bf7d41942ab273dbe455cdfe938b37bf9e6ec8fff30807c310692a26"
    sha256 cellar: :any_skip_relocation, monterey:       "423088a05409f159e0a4ac7c64910ef5df8918cfc0c9db5346a9dd83906ab367"
    sha256 cellar: :any_skip_relocation, big_sur:        "b318183087934c9e4fe5b238565abec594b89c768e52180f5958e5dc64b111da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0aabe32ff3554d87eb7640a36b25c326318818498e8e733b6b1ad102bf57df18"
  end

  depends_on "docutils"
  depends_on "pygments"
  depends_on "python-tabulate"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "alabaster" do
    url "https://files.pythonhosted.org/packages/94/71/a8ee96d1fd95ca04a0d2e2d9c4081dac4c2d2b12f7ddb899c8cb9bfd1532/alabaster-0.7.13.tar.gz"
    sha256 "a27a4a084d5e690e16e01e03ad2b2e552c61a65469419b907243193de1a84ae2"
  end

  resource "babel" do
    url "https://files.pythonhosted.org/packages/ba/42/54426ba5d7aeebde9f4aaba9884596eb2fe02b413ad77d62ef0b0422e205/Babel-2.12.1.tar.gz"
    sha256 "cc2d99999cd01d44420ae725a21c9e3711b3aadc7976d6147f622d8581963455"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/af/0b/44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094/beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "boltons" do
    url "https://files.pythonhosted.org/packages/e1/13/1a38fd4ee194985cfc674358fcf2ca10a80c5b14fafa62abbb1e6088fcab/boltons-23.0.0.tar.gz"
    sha256 "8c50a71829525835ca3c849c7ed2511610c972b4dddfcd41a4a5447222beb4b0"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/b3/96/d53e290ddf6215cfb24f93449a1835eff566f79a1f332cf046a978df0c9e/bracex-2.3.post1.tar.gz"
    sha256 "e7b23fc8b2cd06d3dec0692baabecb249dda94e06a617901ff03a6c56fd71693"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "click-extra" do
    url "https://files.pythonhosted.org/packages/06/04/c7c0cb18120e8cb8629c975ae5e118e5b44b2c0cfaa63dc39b45d779e66f/click_extra-3.10.0.tar.gz"
    sha256 "74e7b65c453c6e2d59f87d63f8fa249ede4362851f4cf32f46e0953d472609d6"
  end

  resource "click-log" do
    url "https://files.pythonhosted.org/packages/32/32/228be4f971e4bd556c33d52a22682bfe318ffe57a1ddb7a546f347a90260/click-log-0.4.0.tar.gz"
    sha256 "3970f8570ac54491237bcdb3d8ab5e3eef6c057df29f8c3d1151a51a9c23b975"
  end

  resource "cloup" do
    url "https://files.pythonhosted.org/packages/cf/27/a155eab49cab519659fba04df294a33d6796739f1328e410622588f2e29d/cloup-2.1.0.tar.gz"
    sha256 "dd42c7c9cd493fadc53a4236f96178a3f118bbbd945a7f8adafcd5034d826971"
  end

  resource "commentjson" do
    url "https://files.pythonhosted.org/packages/c0/76/c4aa9e408dbacee3f4de8e6c5417e5f55de7e62fb5a50300e1233a2c9cb5/commentjson-0.9.0.tar.gz"
    sha256 "42f9f231d97d93aff3286a4dc0de39bfd91ae823d1d9eba9fa901fe0c7113dd4"
  end

  resource "furo" do
    url "https://files.pythonhosted.org/packages/d3/21/233938933f1629a4933c8fce2f803cc8fd211ca563ea4337cb44920bbbfa/furo-2023.3.27.tar.gz"
    sha256 "b99e7867a5cc833b2b34d7230631dd6558c7a29f93071fdbb5709634bb33c5a5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "imagesize" do
    url "https://files.pythonhosted.org/packages/a7/84/62473fb57d61e31fef6e36d64a179c8781605429fd927b5dd608c997be31/imagesize-1.4.1.tar.gz"
    sha256 "69150444affb9cb0d5cc5a92b3676f0b2fb7cd9ae39e947a5e11a36b4497cd4a"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "lark-parser" do
    url "https://files.pythonhosted.org/packages/34/b8/aa7d6cf2d5efdd2fcd85cf39b33584fe12a0f7086ed451176ceb7fb510eb/lark-parser-0.7.8.tar.gz"
    sha256 "26215ebb157e6fb2ee74319aa4445b9f3b7e456e26be215ce19fdaaa901c20a4"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/95/7e/68018b70268fb4a2a605e2be44ab7b4dd7ce7808adae6c5ef32e34f4b55a/MarkupSafe-2.1.2.tar.gz"
    sha256 "abcabc8c2b26036d62d4c746381a6f7cf60aafcc653198ad678306986b09450d"
  end

  resource "mergedeep" do
    url "https://files.pythonhosted.org/packages/3a/41/580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270/mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/91/c7/47a411700a121acc05fe78642b019afe320592078e58c182537c7c65006f/packageurl-python-0.11.1.tar.gz"
    sha256 "bbcc53d2cb5920c815c1626c75992f319bfc450b73893fa7bd8aac5869aa49fe"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "pallets-sphinx-themes" do
    url "https://files.pythonhosted.org/packages/44/03/d1a4e5a06e116a17e9b0abb9f8c7865c2e5d863543f153b403ce1ac9d559/Pallets-Sphinx-Themes-2.1.0.tar.gz"
    sha256 "4b2536495e58facce6047cf481f613558f11c89351f913f392b8eba002c6b7c7"
  end

  resource "pygments-ansi-color" do
    url "https://files.pythonhosted.org/packages/b2/93/af2feb6f3f436a44fbe20c0b6861641ad01f00139d96ae27a2649149bad3/pygments-ansi-color-0.2.0.tar.gz"
    sha256 "8e2f9a57873b4b28d6b95a8f1c9f346be5fc0f9e4f4a316594584a0684aa7959"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/27/b5/92d404279fd5f4f0a17235211bb0f5ae7a0d9afb7f439086ec247441ed28/regex-2022.10.31.tar.gz"
    sha256 "a3a98921da9a1bf8457aeee6a551948a83601689e5ecdd736894ea9bbec77e83"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "snowballstemmer" do
    url "https://files.pythonhosted.org/packages/44/7b/af302bebf22c749c56c9c3e8ae13190b5b5db37a33d9068652e8f73b7089/snowballstemmer-2.2.0.tar.gz"
    sha256 "09b16deb8547d3412ad7b590689584cd0fe25ec8db3be37788be3810cbf19cb1"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/47/9e/780779233a615777fbdf75a4dee2af7a345f4bf74b42d4a5f836800b9d91/soupsieve-2.4.1.tar.gz"
    sha256 "89d12b2d5dfcd2c9e8c22326da9d9aa9cb3dfab0a83a024f05704076ee8d35ea"
  end

  resource "sphinx" do
    url "https://files.pythonhosted.org/packages/af/b2/02a43597980903483fe5eb081ee8e0ba2bb62ea43a70499484343795f3bf/Sphinx-5.3.0.tar.gz"
    sha256 "51026de0a9ff9fc13c05d74913ad66047e104f56a129ff73e174eb5c3ee794b5"
  end

  resource "sphinx-basic-ng" do
    url "https://files.pythonhosted.org/packages/80/77/df8674b4c0eb26d5a3817858ec83f103389c7c1ce31f7d31b13394a6ff0e/sphinx_basic_ng-1.0.0b1.tar.gz"
    sha256 "89374bd3ccd9452a301786781e28c8718e99960f2d4f411845ea75fc7bb5a9b0"
  end

  resource "sphinxcontrib-applehelp" do
    url "https://files.pythonhosted.org/packages/32/df/45e827f4d7e7fcc84e853bcef1d836effd762d63ccb86f43ede4e98b478c/sphinxcontrib-applehelp-1.0.4.tar.gz"
    sha256 "828f867945bbe39817c210a1abfd1bc4895c8b73fcaade56d45357a348a07d7e"
  end

  resource "sphinxcontrib-devhelp" do
    url "https://files.pythonhosted.org/packages/98/33/dc28393f16385f722c893cb55539c641c9aaec8d1bc1c15b69ce0ac2dbb3/sphinxcontrib-devhelp-1.0.2.tar.gz"
    sha256 "ff7f1afa7b9642e7060379360a67e9c41e8f3121f2ce9164266f61b9f4b338e4"
  end

  resource "sphinxcontrib-htmlhelp" do
    url "https://files.pythonhosted.org/packages/b3/47/64cff68ea3aa450c373301e5bebfbb9fce0a3e70aca245fcadd4af06cd75/sphinxcontrib-htmlhelp-2.0.1.tar.gz"
    sha256 "0cbdd302815330058422b98a113195c9249825d681e18f11e8b1f78a2f11efff"
  end

  resource "sphinxcontrib-jsmath" do
    url "https://files.pythonhosted.org/packages/b2/e8/9ed3830aeed71f17c026a07a5097edcf44b692850ef215b161b8ad875729/sphinxcontrib-jsmath-1.0.1.tar.gz"
    sha256 "a9925e4a4587247ed2191a22df5f6970656cb8ca2bd6284309578f2153e0c4b8"
  end

  resource "sphinxcontrib-qthelp" do
    url "https://files.pythonhosted.org/packages/b1/8e/c4846e59f38a5f2b4a0e3b27af38f2fcf904d4bfd82095bf92de0b114ebd/sphinxcontrib-qthelp-1.0.3.tar.gz"
    sha256 "4c33767ee058b70dba89a6fc5c1892c0d57a54be67ddd3e7875a18d14cba5a72"
  end

  resource "sphinxcontrib-serializinghtml" do
    url "https://files.pythonhosted.org/packages/b5/72/835d6fadb9e5d02304cf39b18f93d227cd93abd3c41ebf58e6853eeb1455/sphinxcontrib-serializinghtml-1.1.5.tar.gz"
    sha256 "aa5f6de5dfdf809ef505c4895e51ef5c9eac17d0f287933eb49ec495280b6952"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/49/05/6bf21838623186b91aedbda06248ad18f03487dc56fbc20e4db384abde6c/tomli_w-1.0.0.tar.gz"
    sha256 "f463434305e0336248cac9c2dc8076b707d8a12d019dd349f5c1e382dd1ae1b9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/fb/c0/1abba1a1233b81cf2e36f56e05194f5e8a0cec8c03c244cab56cc9dfb5bd/urllib3-2.0.2.tar.gz"
    sha256 "61717a1095d7e155cdb737ac7bb2f4324a858a1e2e6466f6d03ff630ca68d3cc"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/b7/94/5dd083fc972655f6689587c3af705aabc8b8e781bacdf22d6d2282fe6142/wcmatch-8.4.1.tar.gz"
    sha256 "b1f042a899ea4c458b7321da1b5e3331e3e0ec781583434de1301946ceadb943"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Check mpm is reporting the correct version of itself.
    assert_match "mpm, version #{version}", shell_output("#{bin}/mpm --version")
    # Check mpm is reporting its usage in help screen.
    assert_match "Usage: mpm [OPTIONS] COMMAND [ARGS]...", shell_output("#{bin}/mpm --help")
    # Check mpm is detecting brew and report it as a manager in a table row.
    assert_match(
      /\e\[32mbrew\e\[0m,Homebrew Formulae,\e\[32m✓\e\[0m,\e\[32m✓\e\[0m \S+,\e\[32m✓\e\[0m,\e\[32m✓\e\[0m \S+/,
      shell_output("#{bin}/mpm --output-format csv --all-managers managers"),
    )
    # Check mpm is reporting itself as installed via brew in a table row.
    assert_match "meta-package-manager,,brew,#{version}", shell_output("#{bin}/mpm --output-format csv installed")
  end
end