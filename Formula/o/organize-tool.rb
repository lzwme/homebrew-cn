class OrganizeTool < Formula
  include Language::Python::Virtualenv

  desc "File management automation tool"
  homepage "https://github.com/tfeldmann/organize"
  url "https://files.pythonhosted.org/packages/3c/bd/1b4217217aadce0d46e28042c0e06bb28863bfdfb383ce7afb18f69a1553/organize_tool-3.3.0.tar.gz"
  sha256 "034fdcf9ffeb23d21b495e038665278e589fa04dc7c0c0a01a4a3b30a06c539f"
  license "MIT"
  head "https://github.com/tfeldmann/organize.git", branch: "main"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:   "82f2d77b517f37e35f50676b15ec7c9e6f80d43b2c53dfab649c722912ba4f95"
    sha256 cellar: :any,                 arm64_sequoia: "4e2acbe0d1b7d0dac77d8d6bc1cb3ea12bece402305b5d7b8e3081b180f6cdcd"
    sha256 cellar: :any,                 arm64_sonoma:  "9ae3771db125f2270a6455d1ac603942eda74347ea433d9b8f0bcfc1263d7cc7"
    sha256 cellar: :any,                 sonoma:        "8153a2c04f628593063397b7672519f00b4e526b2c5cf1ec10e4a4c521686d37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f659544fc071c5bb66a2d0d1c385cfa6fb013275850e86ba1ebf56e00ab9cdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3ab8fce87d692379b3d64d0cd2fb6a7ef15adbb17391ef32b2bb9b2f5e08cb3"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build # for macos-tags
  depends_on "cryptography" => :no_linkage
  depends_on "freetype"
  depends_on "libyaml"
  depends_on "openjpeg"
  depends_on "pydantic-core" => :no_linkage
  depends_on "python@3.14"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
  end

  pypi_packages exclude_packages: ["cryptography", "pydantic-core"],
                extra_packages:   "pyobjc-framework-cocoa"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/b9/33/032cdc44182491aa708d06a68b62434140d8c50820a087fac7af37703357/arrow-1.4.0.tar.gz"
    sha256 "ed0cc050e98001b8779e84d461b0098c4ac597e88704a655582b21d116e526d7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "docopt-ng" do
    url "https://files.pythonhosted.org/packages/e4/50/8d6806cf13138127692ae6ff79ddeb4e25eb3b0bcc3c1bd033e7e04531a9/docopt_ng-0.9.0.tar.gz"
    sha256 "91c6da10b5bb6f2e9e25345829fb8278c78af019f6fc40887ad49b060483b1d7"
  end

  resource "docx2txt" do
    url "https://files.pythonhosted.org/packages/7d/7d/60ee3f2b16d9bfdfa72e8599470a2c1a5b759cb113c6fe1006be28359327/docx2txt-0.8.tar.gz"
    sha256 "2c06d98d7cfe2d3947e5760a57d924e3ff07745b379c8737723922e7009236e5"
  end

  resource "exifread" do
    url "https://files.pythonhosted.org/packages/5f/a6/e5bdca841e5cc1a0eb7b9bf64854a4bf4e19e6de1a14092f93b8c907e87a/ExifRead-2.3.2.tar.gz"
    sha256 "a0f74af5040168d3883bbc980efe26d06c89f026dc86ba28eb34107662d51766"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "macos-tags" do
    url "https://files.pythonhosted.org/packages/d4/6e/e0b2ea37ef831a5c6b5aebbd14701d96d9dc061f04a867b05335a4bc099d/macos-tags-1.5.1.tar.gz"
    sha256 "f144c5bc05d01573966d8aca2483cb345b20b76a5b32e9967786e086a38712e7"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mdfind-wrapper" do
    url "https://files.pythonhosted.org/packages/0e/74/148968c2665c0f2db1fbd470fbb454b1f808ea5d4cb8d75bc99f451d0ece/mdfind-wrapper-0.1.5.tar.gz"
    sha256 "c0dbd5bc99c6d1fb4678bfa1841a3380ccac61e9b43a26a8d658aa9cafe27441"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "natsort" do
    url "https://files.pythonhosted.org/packages/e2/a9/a0c57aee75f77794adaf35322f8b6404cbd0f89ad45c87197a937764b7d0/natsort-8.4.0.tar.gz"
    sha256 "45312c4a0e5507593da193dedd04abb1469253b601ecaf63445ad80f0a1ea581"
  end

  resource "pdfminer-six" do
    url "https://files.pythonhosted.org/packages/78/46/5223d613ac4963e1f7c07b2660fe0e9e770102ec6bda8c038400113fb215/pdfminer_six-20250506.tar.gz"
    sha256 "b03cc8df09cf3c7aba8246deae52e0bca7ebb112a38895b5e1d4f5dd2b8ca2e7"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/f3/1e/4f0a3233767010308f2fd6bd0814597e3f63f1dc98304a9112b8759df4ff/pydantic-2.12.3.tar.gz"
    sha256 "1da1c82b0fc140bb0103bc1441ffe062154c8d38491189751ee00fd8ca65ce74"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/ab/dc/6d63019133e39e2b299dfbab786e64997fff0f145c45a417e1dd51faaf3f/pyobjc_core-12.0.tar.gz"
    sha256 "7e05c805a776149a937b61b892a0459895d32d9002bedc95ce2be31ef1e37a29"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/37/6f/89837da349fe7de6476c426f118096b147de923139556d98af1832c64b97/pyobjc_framework_cocoa-12.0.tar.gz"
    sha256 "02d69305b698015a20fcc8e1296e1528e413d8cf9fdcd590478d359386d76e8a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ab/3a/0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bc/rich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "send2trash" do
    url "https://files.pythonhosted.org/packages/fd/3a/aec9b02217bb79b87bbc1a21bc6abc51e3d5dcf65c30487ac96c0908c722/Send2Trash-1.8.3.tar.gz"
    sha256 "b18e7a3966d99871aefeb00cfbcfdced55ce4871194810fc71f4aa484b953abf"
  end

  resource "simplematch" do
    url "https://files.pythonhosted.org/packages/d4/c5/209aa49f6c366f5b1d80e9eef2f75270079df3c9dec4658e0716e4bcd6ab/simplematch-1.4.tar.gz"
    sha256 "55a77278b3d0686cb38e3ffe5a326a5f59c2995f1ba1fa1a4f68872c17caf4cb"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/55/e3/70399cb7dd41c10ac53367ae42139cf4b1ca5f36bb3dc6c9d33acdb43655/typing_inspection-0.4.2.tar.gz"
    sha256 "ba561c48a67c5958007083d386c3295464928b01faa735ab8547c5692e87f464"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/95/32/1a225d6164441be760d75c2c42e2780dc0873fe382da3e98a2e1e48361e5/tzdata-2025.2.tar.gz"
    sha256 "b60a638fcc0daffadf82fe0f57e53d06bdec2f36c4df66280ae79bce6bd6f2b9"
  end

  resource "xattr" do
    url "https://files.pythonhosted.org/packages/91/ac/5898d1811abc88c3710317243168feff61ce12be220b9c92ee045ecd66c4/xattr-0.9.9.tar.gz"
    sha256 "09cb7e1efb3aa1b4991d6be4eb25b73dc518b4fe894f0915f5b0dcede972f346"
  end

  def install
    if OS.mac?
      # Help `pyobjc-framework-cocoa` pick correct SDK after removing -isysroot from Python formula
      ENV.append_to_cflags "-isysroot #{MacOS.sdk_path}"
      # pyobjc-core uses "-fdisable-block-signature-string" introduced in clang 17
      ENV.llvm_clang if DevelopmentTools.clang_build_version <= 1699
    else
      # `macos-tags` and `pyobjc-framework-cocoa` + dependencies are only needed on macOS
      # TODO: Currently requires manual check to confirm PyPI dependency tree
      without = resources.filter_map { |r| r.name if r.name.start_with?("pyobjc") }
      without += %w[macos-tags mdfind-wrapper xattr]
    end
    virtualenv_install_with_resources(without:)
  end

  test do
    config_file = testpath/"config.yaml"
    config_file.write <<~YAML
      rules:
        - locations: #{testpath}
          filters:
            - extension: txt
          actions:
            - echo: 'Found: {path.name}'
            - delete
    YAML

    touch testpath/"homebrew.txt"

    assert_match "Found: homebrew.txt", shell_output("#{bin}/organize sim #{config_file}")
    system bin/"organize", "run", config_file
    refute_path_exists testpath/"homebrew.txt"
  end
end