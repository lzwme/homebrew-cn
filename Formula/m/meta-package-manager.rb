class MetaPackageManager < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Wrapper around all package managers with a unifying CLI"
  homepage "https:kdeldycke.github.iometa-package-manager"
  url "https:files.pythonhosted.orgpackages5b49d4e663f67c2376f4e26864fa10ec78a6047f765d580daa6a510766ef2d2bmeta_package_manager-5.21.0.tar.gz"
  sha256 "9d438f4cf34b2bebbd46525759f6d5305d98e9ff02975be4e1b18befc4fffffa"
  license "GPL-2.0-or-later"
  revision 2
  head "https:github.comkdeldyckemeta-package-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3b76194c131eec7f94c39eb56af545aca112f7a2abab10b190f2473d161f8716"
    sha256 cellar: :any,                 arm64_sonoma:  "b8dd2d1ee0388db84b26a3b1ec2ea0d37eee72f5ce50ce2821d4c4a145fbec60"
    sha256 cellar: :any,                 arm64_ventura: "3c09ac51da7a00f7b733440d9d7630226cf68a45d85ef8ba27aa371f2e76f565"
    sha256 cellar: :any,                 sonoma:        "fb3b8eee8b71b57c7164d96c1efcf01df3fcd8d486a42839f3c64f5b9fcfd6e5"
    sha256 cellar: :any,                 ventura:       "2c811dd3897778fb90dce7a74a6f31907bd945592a637b80a0bc55f9c45f4b09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55a2543423f626da0297a66a9cc64fec0f4e8c1faaa853a01e149136e6a33d86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb0f47a483a944b6baab6f6f0c2c981217f5d73c627ca95330c67e7433196b43"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "arrow" do
    url "https:files.pythonhosted.orgpackages2e000f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages5ab01367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "beartype" do
    url "https:files.pythonhosted.orgpackages0df921e5a9c731e14f08addd53c71fea2e70794e009de5b98e6a2c3d2f3015d6beartype-0.21.0.tar.gz"
    sha256 "f9a5078f5ce87261c2d22851d19b050b64f6a805439e8793aecf01ce660d3244"
  end

  resource "boltons" do
    url "https:files.pythonhosted.orgpackages635471a94d8e02da9a865587fb3fff100cb0fc7aa9f4d5ed9ed3a591216ddcc7boltons-25.0.0.tar.gz"
    sha256 "e110fbdc30b7b9868cb604e3f71d4722dd8f4dcb4a5ddd06028ba8f1ab0b5ace"
  end

  resource "boolean-py" do
    url "https:files.pythonhosted.orgpackagesc4cf85379f13b76f3a69bca86b60237978af17d6aa0bc5998978c3b8cf05abb2boolean_py-5.0.tar.gz"
    sha256 "60cbc4bad079753721d32649545505362c754e121570ada4658b852a3a318d95"
  end

  resource "bracex" do
    url "https:files.pythonhosted.orgpackagesd66c57418c4404cd22fe6275b8301ca2b46a8cdaa8157938017a9ae0b3edf363bracex-2.5.post1.tar.gz"
    sha256 "12c50952415bfa773d2d9ccb8e79651b8cdb1f31a42f6091b804f6ba2b4a66b6"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages606c8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbcclick-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "click-extra" do
    url "https:files.pythonhosted.orgpackagese33332aea2ec2bbb3c3723a8a46a50e210637cd20686447a0977738fe3b51032click_extra-5.0.2.tar.gz"
    sha256 "53d7ce1a048c8777fa4efcc9c8d786d09a99484cf9cc6de91e258055af36265d"
  end

  resource "cloup" do
    url "https:files.pythonhosted.orgpackages86c93c621e0b7898403556e807244104095df1132a6094384f80c272bba4e4e4cloup-3.0.7.tar.gz"
    sha256 "c852e0a0541aa433c6ab31a9b8b503f63d9881e91ddaf0384d6927965f2b421c"
  end

  resource "cyclonedx-python-lib" do
    url "https:files.pythonhosted.orgpackagesa17075c253be1ec80bd25d14ce900ff1d49d96e0ed21368fb7117868b55cc0a2cyclonedx_python_lib-10.0.2.tar.gz"
    sha256 "2722ec36d5acc8d41117946967864094571bdc847986e41cfd74415ec9d02fd4"
  end

  resource "defusedxml" do
    url "https:files.pythonhosted.orgpackages0fd5c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "distro" do
    url "https:files.pythonhosted.orgpackagesfcf898eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "extra-platforms" do
    url "https:files.pythonhosted.orgpackagesc5c923e1e12c48d684d9cb9977ddf5715de08b4a7a2bb954a2542d9252644b0fextra_platforms-3.2.2.tar.gz"
    sha256 "71ff20f757e0a73204cd5142caf0d35760ea8304a5bbd914c78fc3bdb6bdd8ea"
  end

  resource "fqdn" do
    url "https:files.pythonhosted.orgpackages303ea80a8c077fd798951169626cde3e239adeba7dab75deb3555716415bd9b0fqdn-1.5.1.tar.gz"
    sha256 "105ed3677e767fb5ca086a0c1f4bb66ebc3c100be518f0e0d755d9eae164d89f"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "iniconfig" do
    url "https:files.pythonhosted.orgpackagesf297ebf4da567aa6827c909642694d71c9fcf53e5b504f2d96afea02718862f3iniconfig-2.1.0.tar.gz"
    sha256 "3abbd2e30b36733fee78f9c7f7308f2d0050e88f0087fd25c2645f63c773e1c7"
  end

  resource "isoduration" do
    url "https:files.pythonhosted.orgpackages7c1a3c8edc664e06e6bd06cce40c6b22da5f1429aa4224d0c590f3be21c91eadisoduration-20.11.0.tar.gz"
    sha256 "ac2f9015137935279eac671f94f89eb00584f940f5dc49462a0c4ee692ba1bd9"
  end

  resource "jsonpointer" do
    url "https:files.pythonhosted.orgpackages6a0aeebeb1fa92507ea94016a2a790b93c2ae41a7e18778f85471dc54475ed25jsonpointer-3.0.0.tar.gz"
    sha256 "2b2d729f2091522d61c3b31f82e11870f60b68f43fbc705cb76bf4b832af59ef"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackagesbfd31cf5326b923a53515d8f3a2cd442e6d7e94fcc444716e879ea70a0ce3177jsonschema-4.24.0.tar.gz"
    sha256 "0b4e8069eb12aedfa881333004bccaec24ecef5a8a6a4b6df142b2cc9599d196"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackagesbfce46fbd9c8119cfc3581ee5643ea49464d168028cfb5caff5fc0596d0cf914jsonschema_specifications-2025.4.1.tar.gz"
    sha256 "630159c9f4dbea161a6a2205c3011cc4f18ff381b189fff48bb39b9bf26ae608"
  end

  resource "license-expression" do
    url "https:files.pythonhosted.orgpackages746f8709031ea6e0573e6075d24ea34507b0eb32f83f10e1420f2e34606bf0dalicense_expression-30.4.1.tar.gz"
    sha256 "9f02105f9e0fcecba6a85dfbbed7d94ea1c3a70cf23ddbfb5adf3438a6f6fce0"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackages763d14e82fc7c8fb1b7761f7e748fd47e2ec8276d137b6acfe5a4bb73853e08flxml-5.4.0.tar.gz"
    sha256 "d12832e1dbea4be280b22fd0ea7c9b87f0d8fc51ba06e92dc62d52f804f78ebd"
  end

  resource "mergedeep" do
    url "https:files.pythonhosted.orgpackages3a41580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "more-itertools" do
    url "https:files.pythonhosted.orgpackagescea0834b0cebabbfc7e311f30b46c8188790a37f89fc8d756660346fe5abfd09more_itertools-10.7.0.tar.gz"
    sha256 "9fddd5403be01a94b204faadcff459ec3568cf110265d3c54323e1e866ad29d3"
  end

  resource "packageurl-python" do
    url "https:files.pythonhosted.orgpackages687d0bd319dc94c7956b4d864e87d3dc03739f125ce174671e3128edd566a63epackageurl_python-0.16.0.tar.gz"
    sha256 "69e3bf8a3932fe9c2400f56aaeb9f86911ecee2f9398dbe1b58ec34340be365d"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesa1d41fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24dpackaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pluggy" do
    url "https:files.pythonhosted.orgpackagesf9e23e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "ply" do
    url "https:files.pythonhosted.orgpackagese569882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4daply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "py-serializable" do
    url "https:files.pythonhosted.orgpackagesf075813967eae0542776314c6def33feac687642a193b9d5591c20684b2eafd8py_serializable-2.0.0.tar.gz"
    sha256 "e9e6491dd7d29c31daf1050232b57f9657f9e8a43b867cca1ff204752cf420a5"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackagesbb22f1129e69d94ffff626bdb5c835506b3a5b4f3d070f17ea295e12c2c6f60fpyparsing-3.2.3.tar.gz"
    sha256 "b9c13f1ab8b3b542f72e28f634bad4de758ab3ce4546e4301970ad6fa77c38be"
  end

  resource "pytest" do
    url "https:files.pythonhosted.orgpackages08ba45911d754e8eba3d5a841a5ce61a65a685ff1798421ac054f85aa8747dfbpytest-8.4.1.tar.gz"
    sha256 "7c67fd69174877359ed9371ec3af8a3d2b04741818c51e5e99cc1742251fa93c"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "rdflib" do
    url "https:files.pythonhosted.orgpackagese87ecb2d74466bd8495051ebe2d241b1cb1d4acf9740d481126aef19ef2697f5rdflib-7.1.4.tar.gz"
    sha256 "fed46e24f26a788e2ab8e445f7077f00edcf95abb73bcef4b86cefa8b62dd174"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages2fdb98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "rfc3339-validator" do
    url "https:files.pythonhosted.orgpackages28eaa9387748e2d111c3c2b275ba970b735e04e15cdb1eb30693b6b5708c4dbdrfc3339_validator-0.1.4.tar.gz"
    sha256 "138a2abdf93304ad60530167e51d2dfb9549521a836871b88d7f4695d0022f6b"
  end

  resource "rfc3987" do
    url "https:files.pythonhosted.orgpackages14bbf1395c4b62f251a1cb503ff884500ebd248eed593f41b469f89caa3547bdrfc3987-1.3.8.tar.gz"
    sha256 "d3c4d257a560d544e9826b38bc81db676890c79ab9d7ac92b39c7a253d5ca733"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages8ca660184b7fc00dd3ca80ac635dd5b8577d444c57e8e8742cecabfacb829921rpds_py-0.25.1.tar.gz"
    sha256 "8960b6dac09b62dac26e75d7e2c4a22efb835d827a7278c34f72b2b84fa160e3"
  end

  resource "semantic-version" do
    url "https:files.pythonhosted.orgpackages7d31f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sortedcontainers" do
    url "https:files.pythonhosted.orgpackagese8c4ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "spdx-tools" do
    url "https:files.pythonhosted.orgpackagesf1993470b28dc4b64fd29db3b1dcf5e84c743ec88e25ea7b214794f5930f0319spdx-tools-0.8.3.tar.gz"
    sha256 "68b8f9ce2893b5216bd90b2e63f1c821c2884e4ebc4fd295ebbf1fa8b8a94b93"
  end

  resource "tabulate" do
    url "https:files.pythonhosted.orgpackagesecfe802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tomli-w" do
    url "https:files.pythonhosted.orgpackages1975241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fetomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "types-python-dateutil" do
    url "https:files.pythonhosted.orgpackagesef88d65ed807393285204ab6e2801e5d11fbbea811adcaa979a2ed3b67a5ef41types_python_dateutil-2.9.0.20250516.tar.gz"
    sha256 "13e80d6c9c47df23ad773d54b2826bd52dbbb41be87c3f339381c1700ad21ee5"
  end

  resource "uri-template" do
    url "https:files.pythonhosted.orgpackages31c70336f2bd0bcbada6ccef7aaa25e443c118a704f828a0620c6fa0207c1b64uri-template-1.3.0.tar.gz"
    sha256 "0e00f8eb65e18c7de20d595a14336e9f337ead580c70934141624b6d1ffdacc7"
  end

  resource "uritools" do
    url "https:files.pythonhosted.orgpackages36b1e482d43db3209663b82a59e37cf31f641254180190667c6b0bf18a297de8uritools-5.0.0.tar.gz"
    sha256 "68180cad154062bd5b5d9ffcdd464f8de6934414b25462ae807b00b8df9345de"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages15229ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bcurllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "wcmatch" do
    url "https:files.pythonhosted.orgpackages41abb3a52228538ccb983653c446c1656eddf1d5303b9cb8b9aef6a91299f862wcmatch-10.0.tar.gz"
    sha256 "e72f0de09bba6a04e0de70937b0cf06e55f36f37b3deb422dfaf854b867b840a"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "webcolors" do
    url "https:files.pythonhosted.orgpackages7b29061ec845fb58521848f3739e466efd8250b4b7b98c1b6c5bf4d40b419b7ewebcolors-24.11.1.tar.gz"
    sha256 "ecb3d768f32202af770477b8b65f318fa4f566c22948673a977b00d589dd80f6"
  end

  resource "xmltodict" do
    url "https:files.pythonhosted.orgpackages500551dcca9a9bf5e1bce52582683ce50980bcadbc4fa5143b9f2b19ab99958fxmltodict-0.14.2.tar.gz"
    sha256 "201e7c28bb210e374999d1dde6382923ab0ed1a8a5faeece48ab525b7810a553"
  end

  def install
    rewrite_shebang detected_python_shebang, "meta_package_managerbar_plugin.py"
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"mpm", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}mpm --version")

    # Check mpm is detecting brew and report it as a manager in a table row.
    assert_match(
      \e\[32mbrew\e\[0m,Homebrew Formulae,\e\[32m✓\e\[0m,\e\[32m✓\e\[0m \S+,\e\[32m✓\e\[0m,\e\[32m✓\e\[0m \S+,
      shell_output("#{bin}mpm --output-format csv --all-managers managers"),
    )
    # Check mpm is reporting itself as installed via brew in a table row.
    assert_match "meta-package-manager,,brew,#{version}", shell_output("#{bin}mpm --output-format csv installed")
  end
end