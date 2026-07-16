class Vsview < Formula
  include Language::Python::Virtualenv

  desc "Next-generation VapourSynth previewer"
  homepage "https://jaded-encoding-thaumaturgy.github.io/vs-view/"
  url "https://files.pythonhosted.org/packages/5d/0d/cf9002dd2939d64b2da3d180a965780729aa8b446218490b9366d56c1208/vsview-0.8.1.tar.gz"
  sha256 "57cf95168383321a5288431e64a2cae3a6a9adc3af341df7be900fd503fbd4b3"
  license all_of: [
    "EUPL-1.2",
    all_of: ["MIT", "Apache-2.0", "ISC", "OFL-1.1"], # src/vsview/assets/
  ]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4e4b3332f4b5121fc2b23f7c1217f03491b485ab32b1274c2869d7ce62548a65"
    sha256 cellar: :any, arm64_sequoia: "989a42ef3bdb4525036aeaf9986f1d348d9c5ffa5a32b272462c35a831dc6eef"
    sha256 cellar: :any, arm64_sonoma:  "82efd1517c08597d0942428fe7b6603565663a36d52aa1bfb09890e1dfe39eac"
    sha256 cellar: :any, sonoma:        "914fdf1ed4b50571be8cfa3c0f3e857b3f79ceb948e7560777a6668a11a9bb84"
    sha256 cellar: :any, arm64_linux:   "032c26693045caad531c5c48b81e3c0c3093e2b8d92f08d16952c45343771585"
    sha256 cellar: :any, x86_64_linux:  "80c66936dfbb1536444ffca0c9a70b144a586ad5df00b8426afeb3931f5cdb75"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "numpy"
  depends_on "pydantic" => :no_linkage
  depends_on "pyside"
  depends_on "python@3.14"
  depends_on "vapoursynth"
  depends_on "vapoursynth-bestsource" => :no_linkage
  depends_on "zstd"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "cryptography"
  end

  pypi_packages package_name:     "vsview[recommended]",
                exclude_packages: %w[cryptography numpy pyside6 pydantic vapoursynth
                                     vapoursynth-bestsource vapoursynth-akarin],
                extra_packages:   %w[jeepney secretstorage] # Linux-only

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/bd/2a/23f34ec9d04624958e137efdc394888716353190e75f25dd22c7a2c7a8aa/charset_normalizer-3.4.9.tar.gz"
    sha256 "673611bbd43f0810bec0b0f028ddeaaa501190339cac411f347ac76917c3ae7b"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
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
    url "https://files.pythonhosted.org/packages/6c/1f/c23395957d41ccf27c4e535c3d334c4051e5395b3752057ba4cbaec35c56/jaraco_functools-4.6.0.tar.gz"
    sha256 "880c577ec9720b3a052d5bc611fb9f2269b3d87902ef42440df443b88e443280"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "jetpytools" do
    url "https://files.pythonhosted.org/packages/13/bb/6c57b9a53f8bc6c4c01c00fe76109f665d55218e581bc987cd00e201e42a/jetpytools-2.2.7.tar.gz"
    sha256 "4063155f3e33283273a899d9b2c80104c6cf0c365abc3aa8c95c9dfd901fa6ec"
  end

  resource "jh2" do
    url "https://files.pythonhosted.org/packages/47/b1/b2b7389b2e0ddac90a1aecbf4a761db8790de85dace7695c01173ed083cc/jh2-5.0.13.tar.gz"
    sha256 "f8c78cffb3a35c4410513c3eb7989de36028c84277c04f07c97909dd94c23a75"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/de/1d/f4da6f02cdffe04d6362210b807146a26044c88d839208aec273bb0d9184/more_itertools-11.1.0.tar.gz"
    sha256 "48e8f4d9e7e5878571ecf6f2b4e57634f93cd474cc8cfbd2376f2d11b396e30d"
  end

  resource "niquests" do
    url "https://files.pythonhosted.org/packages/f2/6f/c2310e0c0d09ef1c22d235ef82d2d5d16f6b04b3a3702ebe1bc8d1dfbd6c/niquests-3.20.1.tar.gz"
    sha256 "55951812cf997963bfef8e4f797ff0460ca571e53ec184039b010e12152c0e41"
  end

  resource "pathvalidate" do
    url "https://files.pythonhosted.org/packages/fa/2a/52a8da6fe965dea6192eb716b357558e103aea0a1e9a8352ad575a8406ca/pathvalidate-3.3.1.tar.gz"
    sha256 "b18c07212bfead624345bb8e1d6141cdcf15a39736994ea0b94035ad2b1ba177"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/47/e4501f49c178ae1d9f4a75073fda4204f52647993f075a9db4d14930e0c5/platformdirs-4.10.0.tar.gz"
    sha256 "31e761a6a0ca04faf7353ea759bdba55652be214725111e5aac52dfa29d4bef7"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/82/ed/0301aeeac3e5353ef3d94b6ec08bbcabd04a72018415dcb29e588514bba8/python_dotenv-1.2.2.tar.gz"
    sha256 "2c371a91fbd7ba082c2c1dc1f8bf89ca22564a087c2c287cd9b662adde799cf3"
  end

  resource "qh3" do
    url "https://files.pythonhosted.org/packages/72/ae/9d42d6df0ab9a014138332346fd690f7b0be0556861421d2459caec28d6f/qh3-1.9.4.tar.gz"
    sha256 "bd2ea9baf19656c544a48a56a195f2ac257cd973b566f5f2998fa3b7446281a1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/1c/03/e834bcd866f2f8a49a85eaff47340affa3bfa391ee9912a952a1faa68c7b/secretstorage-3.5.0.tar.gz"
    sha256 "f04b8e4689cbce351744d5537bf6b1329c6fc68f91fa666f60a380edddcd11be"
  end

  resource "urllib3-future" do
    url "https://files.pythonhosted.org/packages/c4/81/10f2b68f02f3fcfcd476c8839bee0a8121f0f6740326233755869236e2b6/urllib3_future-2.22.901.tar.gz"
    sha256 "fbece0ff51299a213c926897ffbed61d820ab5ef2ba81cece361c049fe2f51a9"
  end

  resource "vapoursynth-fftspectrum-rs" do
    url "https://files.pythonhosted.org/packages/13/56/9771adfbc1195017e887142cf03253316efac3d21d2f7f10900bdcf628df/vapoursynth_fftspectrum_rs-1.0.13.tar.gz"
    sha256 "bd2347222d833d82ba8f3b4e4cf45aea6276b7c48e5c3eb510198520bf15ebe6"
  end

  resource "vsjetengine" do
    url "https://files.pythonhosted.org/packages/10/7b/b483c48cf174ad8d1ee1e16c18419b0501a32dbee3e8a92bd52e36ddc804/vsjetengine-1.5.1.tar.gz"
    sha256 "eb703a6f88d589ec9344952b812a82e797650334821de25564d7a191fff17885"
  end

  resource "vsjetpack" do
    url "https://files.pythonhosted.org/packages/a6/df/37da0c9b40e29f43d37540e63ad88a4af478fb4807118af8e88e2fb87a0b/vsjetpack-1.5.0.tar.gz"
    sha256 "1c9a410329c60ee0058a1bf6a84b692f85db68154de55d04a80ea43f25a5c1cf"
  end

  resource "vspackrgb" do
    url "https://files.pythonhosted.org/packages/f4/7f/d487740b694d6e99522301bf594b80492730be77c5ea2902ff528d93122b/vspackrgb-1.4.0.tar.gz"
    sha256 "6f3a227e70c09d9dbc35c5f2500b0d23c7729de8197886c8e511d372d385a5b4"
  end

  resource "vsview-cli" do
    url "https://files.pythonhosted.org/packages/f9/34/69c0786564221ea676aa28642484f10e25a0f1a59bda237cecd077f3049f/vsview_cli-1.1.0.tar.gz"
    sha256 "b119bdb559f64bd340afa8f6d0ab63d20cb2a01dc34e8e343391d8862558752b"
  end

  resource "vsview-comp" do
    url "https://files.pythonhosted.org/packages/4e/ee/0f7422981f495eab1cacb8ab04105f3fd800329ab3594078f4edc94b362f/vsview_comp-0.11.0.tar.gz"
    sha256 "7084f7f7dce8efbbd62f3d4709ea5662b011a1b49266dd2b8f3ad359f7c4ce34"
  end

  resource "vsview-fftspectrum" do
    url "https://files.pythonhosted.org/packages/2d/8f/4361e35f97c1e7bafadf9f9b27578d909c77af57231e54b90740cab4e546/vsview_fftspectrum-0.2.1.tar.gz"
    sha256 "17e14f8fa276b4a569259fd762cc7c79cce1db20aaa8dcc1b548dd95c3b05e5d"
  end

  resource "vsview-frameprops-extended" do
    url "https://files.pythonhosted.org/packages/42/9c/d5c47089966553efba9b42e8fc26b16e0bcd185815682663bf43aba8ad84/vsview_frameprops_extended-0.2.2.tar.gz"
    sha256 "9cc298f0ac558a9c1004c2b8984e3f8338c9709c88271608ffe3f97bc8d22d81"
  end

  resource "vsview-split-planes" do
    url "https://files.pythonhosted.org/packages/4b/52/2cf4c35349c046882fecc29d49c3a713327f8e8c84dc0adb59546cef81b1/vsview_split_planes-0.2.2.tar.gz"
    sha256 "7b4bccf3b0cf4b4e41b139068251bd667fba2392c6470fb18b6ec8211f8d7b8e"
  end

  resource "wassima" do
    url "https://files.pythonhosted.org/packages/d1/9f/be43f3a97d27bd3bcdd572024ed082b55f486e0541834061da6acf9c77c7/wassima-2.1.2.tar.gz"
    sha256 "f74b5441151728c54118ece6d747cfe92b2c595a3d062a1955f42a2bc894cd10"
  end

  def install
    # Work around superenv breaking aws-lc-sys `-O0` needed to build CPU Jitter RNG
    ENV["AWS_LC_SYS_NO_JITTER_ENTROPY"] = "1"

    without = %w[jeepney secretstorage] unless OS.linux?
    virtualenv_install_with_resources(without:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vsview version")

    ENV["COLUMNS"] = "120"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    output_log = testpath/"output.log"
    pid = spawn bin/"vsview", "--no-settings", "--verbose", [:out, :err] => output_log.to_s
    begin
      sleep 10
      assert_match "Plugin integration, finalized", output_log.read
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end