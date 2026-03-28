class GimmeAwsCreds < Formula
  include Language::Python::Virtualenv

  desc "CLI to retrieve AWS credentials from Okta"
  homepage "https://github.com/Nike-Inc/gimme-aws-creds"
  url "https://files.pythonhosted.org/packages/63/73/9e508d37d4d301f6a3811fdc0b0a076696de87f82ad8a81ec28c3e6befb5/gimme_aws_creds-2.8.2.tar.gz"
  sha256 "12784f4b749617d7391bf2056373990277858dc9886328832b545e9e334f24d3"
  license "Apache-2.0"
  revision 9
  head "https://github.com/Nike-Inc/gimme-aws-creds.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4298d6160289126d062e90e3f9bb403b129c5d35d217a7b0ef690c035c5f47df"
    sha256 cellar: :any,                 arm64_sequoia: "4cc97ba7f5087389c76a20fc9e60621cc445350d9e1fbc7d88c08e53392a7eaf"
    sha256 cellar: :any,                 arm64_sonoma:  "3a362feac1252ab2084a64eeb35bb5d4dbc641c9ebaf7a21e1722566c72bd152"
    sha256 cellar: :any,                 sonoma:        "e56617852c88d74864ad49bc26767d54dce1b32ef6513e3004a8c911ba6d5bc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "041574d87365cea511f871d34e039d3e33e02aef5c863299b808bf8075b04a83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5b330a195fed33753ab3453652d594354f4297951327cb0e82ad059f9961565"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.14"

  uses_from_macos "libffi"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
  end

  fails_with :clang do
    build 1699
    cause "pyobjc-core uses `-fdisable-block-signature-string`"
  end

  # Extra package resources are set here for platform-specific dependencies
  # since the output of `bump-formula-pr` and `update-python-resources` is
  # impacted by whether command is run on macOS or Linux. Remove if Homebrew
  # logic is enhanced to handle this. Also, occasionally check if any of these
  # Python dependencies are no longer used.
  #
  # macOS: `pyobjc-framework-localauthentication`, ...
  # - gimme-aws-creds
  #   ├── ctap-keyring-device
  #       └── pyobjc-framework-localauthentication
  #           ├── pyobjc-core
  #           ├── ...
  pypi_packages exclude_packages: %w[certifi cryptography],
                extra_packages:   %w[jeepney pyobjc-framework-localauthentication secretstorage]

  resource "aenum" do
    url "https://files.pythonhosted.org/packages/07/e9/8b283567c1fef7c24d1f390b37daede8b61593d8cdaffb8e95d571699e83/aenum-3.1.17.tar.gz"
    sha256 "a969a4516b194895de72c875ece355f17c0d272146f7fda346ef74f93cf4d5ba"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/50/42/32cf8e7704ceb4481406eb87161349abb46a57fee3f008ba9cb610968646/aiohttp-3.13.3.tar.gz"
    sha256 "a949eee43d3782f2daae4f4a2819b2cb9b0c5d3b7f7a927067cc84dafdbb9f88"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/c3/b0/1c6a16426d389813b48d95e26898aff79abbde42ad353958ad95cc8c9b21/beautifulsoup4-4.14.3.tar.gz"
    sha256 "6292b1c5186d356bba669ef9f7f051757099565ad9ada5dd630bd9de5fa7fb86"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/4e/f6/b280afd91b2284744c0bb26afa1272bd60270726b4d3999fc27b68200854/boto3-1.42.77.tar.gz"
    sha256 "c6d9b05e5b86767d4c6ef762f155c891366e5951162f71d030e109fe531f4fd9"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/42/97/1800633988e890b4eea0706b2671342eddfeb33c1eb1d2fe28a8117f7907/botocore-1.42.77.tar.gz"
    sha256 "cbb0ac410fab4aa0839a521329f970b271ec298d67465ed7fa7d095c0dad9f48"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/7b/60/e3bec1881450851b087e301bedc3daa9377a4d45f1c26aa90b0b235e38aa/charset_normalizer-3.4.6.tar.gz"
    sha256 "1ae6b62897110aa7c79ea2f5dd38d1abca6db663687c0b1ad9aed6f6bae3d9d6"
  end

  resource "ctap-keyring-device" do
    url "https://files.pythonhosted.org/packages/c4/c5/5c4ce510d457679c8886229ddbdc2a84969d63e50fe9fb09d6975d8e500e/ctap-keyring-device-1.0.6.tar.gz"
    sha256 "a44264bb3d30c4ab763e4a3098b136602f873d86b666210d2bb1405b5e0473f6"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/74/6e/58e1bb40a284291ab483d00831c5b91fe14d498a3ae7c658f3c588658e4b/fido2-0.9.3.tar.gz"
    sha256 "b45e89a6109cfcb7f1bb513776aa2d6408e95c4822f83a253918b944083466ec"
  end

  resource "flatdict" do
    url "https://files.pythonhosted.org/packages/1f/ba/e0461697020839f60741e493fc42b20a4cd3f91594ed3228f65ae9a50aee/flatdict-4.1.0.tar.gz"
    sha256 "63bcd906a0859d91d0aace44b327178706c7fcf85a88c7ccf0825628376ad66b"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "furl" do
    url "https://files.pythonhosted.org/packages/53/e4/203a76fa2ef46cdb0a618295cc115220cbb874229d4d8721068335eb87f0/furl-2.1.4.tar.gz"
    sha256 "877657501266c929269739fb5f5980534a41abd6bbabcb367c136d1d3b2a6015"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"

    # Fix to build with Python 3.14
    # PR ref: https://github.com/html5lib/html5lib-python/pull/589
    patch do
      url "https://github.com/html5lib/html5lib-python/commit/b90dafff1bf342d34d539098013d0b9f318c7641.patch?full_index=1"
      sha256 "779f8bab52308792b7ac2f01c3cd61335587640f98812c88cb074dce9fe8162d"
    end

    # Remove pkg_resources for setuptools 81+ compatibility
    # https://github.com/html5lib/html5lib-python/pull/592
    patch do
      url "https://github.com/html5lib/html5lib-python/commit/1dbc19cd6db72cb919885827bc4883423e0cb647.patch?full_index=1"
      sha256 "5951b823f353dd70806ad6e163ab8f46899496c1e8bb53970c99abe8d1df1a78"
    end
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/af/50/4763cd07e722bb6285316d390a164bc7e479db9d90daa769f22578f698b4/jaraco_context-6.1.2.tar.gz"
    sha256 "f1a6c9d391e661cc5b8d39861ff077a7dc24dc23833ccee564b234b81c82dfe3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/0f/27/056e0638a86749374d6f57d0b0db39f29509cce9313cf91bdc0ac4d91084/jaraco_functools-4.4.0.tar.gz"
    sha256 "da21933b0417b89515562656547a77b4931f98176eb173644c0d35032a33d6bb"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "jwcrypto" do
    url "https://files.pythonhosted.org/packages/e1/db/870e5d5fb311b0bcf049630b5ba3abca2d339fd5e13ba175b4c13b456d08/jwcrypto-1.5.6.tar.gz"
    sha256 "771a87762a0c081ae6166958a954f80848820b2ab066937dc8b8379d65b1b039"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ea/5d/38b681d3fce7a266dd9ab73c66959406d565b3e85f21d5e66e1181d93721/more_itertools-10.8.0.tar.gz"
    sha256 "f638ddf8a1a0d134181275fb5d58b086ead7c6a72429ad725c67503f13ba30bd"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/1a/c2/c2d94cbe6ac1753f3fc980da97b3d930efe1da3af3c9f5125354436c073d/multidict-6.7.1.tar.gz"
    sha256 "ec6652a1bee61c53a3e5776b6049172c53b6aaba34f18c9ad04f82712bac623d"
  end

  resource "okta" do
    url "https://files.pythonhosted.org/packages/1c/25/c896ce27690285ea67893b74049359695e182093b75cb8f0ed41e28006bc/okta-2.9.13.tar.gz"
    sha256 "8d8e926751b7f8daae1794df2ec1b0e93f563b8b26781613d205cb9d10e837ef"
  end

  resource "orderedmultidict" do
    url "https://files.pythonhosted.org/packages/5c/62/61ad51f6c19d495970230a7747147ce7ed3c3a63c2af4ebfdb1f6d738703/orderedmultidict-1.0.2.tar.gz"
    sha256 "16a7ae8432e02cc987d2d6d5af2df5938258f87c870675c73ee77a0920e6f4a6"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/9e/da/e9fc233cf63743258bff22b3dfa7ea5baef7b5bc324af47a0ad89b8ffc6f/propcache-0.4.1.tar.gz"
    sha256 "f48107a8c637e80362555f37ecf49abe20370e557cc4ab374f04ec4423c97c3d"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/c9/85/e24bf90972a30b0fcd16c73009add1d7d7cd9140c2498a68252028899e41/pycryptodomex-3.23.0.tar.gz"
    sha256 "71909758f010c82bc99b0abf4ea12012c98962fbf0583c2164f8b84533c2e4da"
  end

  resource "pydash" do
    url "https://files.pythonhosted.org/packages/75/c1/1c55272f49d761cec38ddb80be9817935b9c91ebd6a8988e10f532868d56/pydash-8.0.6.tar.gz"
    sha256 "b2821547e9723f69cf3a986be4db64de41730be149b2641947ecd12e1e11025a"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/c2/27/a3b6e5bf6ff856d2509292e95c8f57f0df7017cf5394921fc4e4ef40308a/pyjwt-2.12.1.tar.gz"
    sha256 "c74a7a2adf861c04d002db713dd85f84beb242228e671280bf709d765b03672b"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/b8/b6/d5612eb40be4fd5ef88c259339e6313f46ba67577a95d86c3470b951fce0/pyobjc_core-12.1.tar.gz"
    sha256 "2bb3903f5387f72422145e1466b3ac3f7f0ef2e9960afa9bcd8961c5cbf8bd21"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/02/a3/16ca9a15e77c061a9250afbae2eae26f2e1579eb8ca9462ae2d2c71e1169/pyobjc_framework_cocoa-12.1.tar.gz"
    sha256 "5556c87db95711b985d5efdaaf01c917ddd41d148b1e52a0c66b1a2e2c5c1640"
  end

  resource "pyobjc-framework-localauthentication" do
    url "https://files.pythonhosted.org/packages/8d/0e/7e5d9a58bb3d5b79a75d925557ef68084171526191b1c0929a887a553d4f/pyobjc_framework_localauthentication-12.1.tar.gz"
    sha256 "2284f587d8e1206166e4495b33f420c1de486c36c28c4921d09eec858a699d05"
  end

  resource "pyobjc-framework-security" do
    url "https://files.pythonhosted.org/packages/80/aa/796e09a3e3d5cee32ebeebb7dcf421b48ea86e28c387924608a05e3f668b/pyobjc_framework_security-12.1.tar.gz"
    sha256 "7fecb982bd2f7c4354513faf90ba4c53c190b7e88167984c2d0da99741de6da9"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/34/64/8860370b167a9721e8956ae116825caff829224fbca0ca6e7bf8ddef8430/requests-2.33.0.tar.gz"
    sha256 "c7ebc5e8b0f21837386ad0e1c8fe8b829fa5f544d8df3b2253bff14ef29d7652"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/05/04/74127fc843314818edfa81b5540e26dd537353b123a4edc563109d8f17dd/s3transfer-0.16.0.tar.gz"
    sha256 "8e990f13268025792229cd52fa10cb7163744bf56e719e0b9cb925ab79abf920"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/1c/03/e834bcd866f2f8a49a85eaff47340affa3bfa391ee9912a952a1faa68c7b/secretstorage-3.5.0.tar.gz"
    sha256 "f04b8e4689cbce351744d5537bf6b1329c6fc68f91fa666f60a380edddcd11be"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/7b/ae/2d9c981590ed9999a0d91755b47fc74f74de286b0f5cee14c9269041e6c4/soupsieve-2.8.3.tar.gz"
    sha256 "3267f1eeea4251fb42728b6dfb746edc9acaffc4a45b27e19450b676586e8349"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e4/e8/6ff5e6bc22095cfc59b6ea711b687e2b7ed4bdb373f7eeec370a97d7392f/urllib3-1.26.20.tar.gz"
    sha256 "40c2dc0c681e47eb8f90e7e27bf6ff7df2e677421fd46756da1161c39ca70d32"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/19/70/80f3b7c10d2630aa66414bf23d210386700aa390547278c789afa994fd7e/xmltodict-1.0.4.tar.gz"
    sha256 "6d94c9f834dd9e44514162799d344d815a3a4faec913717a9ecbfa5be1bb8e61"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/23/6e/beb1beec874a72f23815c1434518bfc4ed2175065173fb138c3705f658d4/yarl-1.23.0.tar.gz"
    sha256 "53b1ea6ca88ebd4420379c330aea57e258408dd0df9af0992e5de2078dc9f5d5"
  end

  def install
    if OS.mac?
      # Help `pyobjc-framework-cocoa` pick correct SDK after removing -isysroot from Python formula
      ENV.append_to_cflags "-isysroot #{MacOS.sdk_path}"
      without = %w[jeepney secretstorage]
    else
      without = resources.filter_map { |r| r.name if r.name.start_with?("pyobjc") }
    end
    virtualenv_install_with_resources(without:)
  end

  test do
    # Workaround gimme-aws-creds bug which runs action-configure twice when config file is missing.
    config_file = Pathname(".okta_aws_login_config")
    touch(config_file)

    assert_match "Okta Configuration Profile Name",
      pipe_output("#{bin}/gimme-aws-creds --profile TESTPROFILE --action-configure 2>&1",
                  "https://something.oktapreview.com\n\n\n\n\n\n\n\n\n\n\n")
    assert_match "", config_file.read

    assert_match version.to_s, shell_output("#{bin}/gimme-aws-creds --version")
  end
end