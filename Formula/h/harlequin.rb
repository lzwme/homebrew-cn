class Harlequin < Formula
  include Language::Python::Virtualenv

  desc "Easy, fast, and beautiful database client for the terminal"
  homepage "https://harlequin.sh"
  url "https://files.pythonhosted.org/packages/1b/f4/57f891b274f67ce48ce433646bf21beb5a0feee181fc2cf8f4a687cffee0/harlequin-2.8.1.tar.gz"
  sha256 "acc71b0588df2ecc4fd7de82d05c50b92d7725d50afb3253e1bc18132fe6bd76"
  license "MIT"
  head "https://github.com/tconbeer/harlequin.git", branch: "main"

  no_autobump! because: "has non-PyPI resources"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a11d31c7d10226d35f1882148aab9f2b6d7d1a9ae75849259a49beb050b89a9a"
    sha256 cellar: :any, arm64_sequoia: "74a46c30890e221d15b9d817395c49b413214c64bd3a6234f3afe08901a96814"
    sha256 cellar: :any, arm64_sonoma:  "21d908657e647138f5fc6127d39432ebc8e86a38c0c71667bed72d0a17daff60"
    sha256 cellar: :any, sonoma:        "fae49a395e4a6c93a53284a02a0d008ee00a08115c45d31f32b0a657d7312851"
    sha256               arm64_linux:   "1459225b7bc85f465578f5d45a49a2914a09e23d81e80d5c178f17a842c76c95"
    sha256               x86_64_linux:  "b85644043947fcc30ec4dd1ee203a8456c6c5e81607bac63d029f7419558e11b"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build # pyarrow > libcst
  depends_on "apache-arrow"
  depends_on "libpq" # psycopg
  depends_on "libyaml" # pyarrow > pyyaml
  depends_on "numpy"
  depends_on "python@3.14"
  depends_on "unixodbc" # harlequin-odbc

  on_linux do
    depends_on "patchelf" => :build # for pyarrow
  end

  pypi_packages package_name:     "harlequin[mysql,odbc,postgres]",
                exclude_packages: %w[numpy psycopg-binary tree-sitter-languages],
                extra_packages:   "psycopg-c"

  resource "click" do
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
  end

  resource "duckdb" do
    url "https://files.pythonhosted.org/packages/7d/19/e57151753576373c6696a12022648546cca6038e8833fda2908ee2342d9b/duckdb-1.5.5.tar.gz"
    sha256 "72f33ee57ca7595b23957671a2cc7f7fe2be0ecc2d68f63abedcfcaa3a5c1238"
  end

  resource "harlequin-mysql" do
    url "https://files.pythonhosted.org/packages/6c/5c/5cd7920799ebd0af14ffd2d85c016ffdc492786bb9b242c8e0b2a71bd60d/harlequin_mysql-1.3.1.tar.gz"
    sha256 "ec06c030888bb6e420448a96c83d9a8f7f7c1714c197ed2b9656fd1355e76dd0"
  end

  resource "harlequin-odbc" do
    url "https://files.pythonhosted.org/packages/c1/1b/e5bc547d98771ce87a8c5ef3c96908e93c95406b50462085a3ebfcd2f86d/harlequin_odbc-0.4.0.tar.gz"
    sha256 "98356c5ebaacc23daff35e165d4490e1ea10dc591fa9cb0824f41272b39d13f0"
  end

  resource "harlequin-postgres" do
    url "https://files.pythonhosted.org/packages/a4/27/18e42a6a524ed28dc94aa26199fe6766f95073c246517e35f157098e5743/harlequin_postgres-1.3.1.tar.gz"
    sha256 "25dcb73e97cdfb17c3bcfdc3146418a98ff11ce68f6a51fb1b25322eac9d5223"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/2e/c9/06ea13676ef354f0af6169587ae292d3e2406e212876a413bf9eece4eb23/linkify_it_py-2.1.0.tar.gz"
    sha256 "43360231720999c10e9328dc3691160e27a718e280673d444c38d7d3aaa3b98b"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/59/fc/f8d0863f8862f25602c0404d75568e89fb6b4109804645e5cdfb1be5cf56/mdit_py_plugins-0.6.1.tar.gz"
    sha256 "a2bca0f039f39dbd35fb74ae1b5f998608c437463371f0ff7f49a19a17a114d0"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "mysql-connector-python" do
    url "https://files.pythonhosted.org/packages/26/c9/a9446dbebbcdf7d828d0a3be9049607eab6eeffb4e46ef1ee8ac304baede/mysql_connector_python-9.7.0.tar.gz"
    sha256 "933887e71c871b6e9d8908459fe8303ebcf8feb5cc1e1c49caa6490e525cf78e"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/be/4f/5f3422a2afec5ffc46308b79e53291365a93748b498ac2e58bead0197916/pandas-3.0.5.tar.gz"
    sha256 "dca3734d6ab7c906e6730f0788b0a1dbb9f2467731f9711f77995c8e9d62d712"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/36/0a/062135c9a98dac804265073cc3afdbec5ae1aa37980bb354f461bafe81b4/platformdirs-4.11.1.tar.gz"
    sha256 "bb1af68078f25e2f3e111e2d43b8d536df41b73c8a684b40bb018223b66fae27"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/fb/93/180be2342f89f16543ec4eb3f25083b5b84eba5378f68efff05409fb39a9/prompt_toolkit-3.0.36.tar.gz"
    sha256 "3e163f254bef5a03b146397d7c1963bd3e2812f0964bb9a24e6ec761fd28db63"
  end

  resource "psycopg" do
    url "https://files.pythonhosted.org/packages/db/2f/cb91e5502ec9de1de6f1b76cfbf69531932725361168bb06963620c77e2e/psycopg-3.3.4.tar.gz"
    sha256 "e21207764952cff81b6b8bdacad9a3939f2793367fdac2987b3aac36a651b5bc"
  end

  resource "psycopg-c" do
    url "https://files.pythonhosted.org/packages/21/7c/c08364f2eab2913e4068b3b955d963e7a3491986a85429990969525def30/psycopg_c-3.3.4.tar.gz"
    sha256 "ed8106128b2d04359c185fc9641b4409abfce4d0b6fb1d1ff6800646e27f1a22"
  end

  resource "psycopg-pool" do
    url "https://files.pythonhosted.org/packages/90/82/7a23d26039827ecd4ebe93905651029ddd307c5182ad59296dfb6f67b528/psycopg_pool-3.3.1.tar.gz"
    sha256 "b10b10b7a175d5cc1592147dc5b7eec8a9e0834eb3ed2c4a92c858e2f51eb63c"
  end

  resource "pyarrow" do
    url "https://files.pythonhosted.org/packages/27/f3/95428098d1fa7d04432fb750eed06b41304c2f6a5d3319985e64db2d9d41/pyarrow-25.0.0.tar.gz"
    sha256 "d2d697008b5ec06d75952ef260c2e9a8a0f6ccfce24266c04c9c8ade927cb3b4"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyodbc" do
    url "https://files.pythonhosted.org/packages/8f/85/44b10070a769a56bd910009bb185c0c0a82daff8d567cd1a116d7d730c7d/pyodbc-5.3.0.tar.gz"
    sha256 "2fe0e063d8fb66efd0ac6dc39236c4de1a45f17c33eaded0d553d21c199f4d05"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "questionary" do
    url "https://files.pythonhosted.org/packages/84/d0/d73525aeba800df7030ac187d09c59dc40df1c878b4fab8669bdc805535d/questionary-2.0.1.tar.gz"
    sha256 "bcce898bf3dbb446ff62830c86c5c6fb9a22a54146f0f5597d3da43b10d8fc8b"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rich-click" do
    url "https://files.pythonhosted.org/packages/f7/ea/21e4867ea0ef881ffd4c0550fc21a061435e50d6324bcd034396633cbc18/rich_click-1.9.8.tar.gz"
    sha256 "4008f921da88b5d91646c134ec881c1500e5a6b3f093e90e8f29400e09608371"
  end

  resource "shandy-sqlfmt" do
    url "https://files.pythonhosted.org/packages/88/a5/d33e5c90339eae4fd0114b3e976333049f2a9ad0479b4b1b955983cb5bb7/shandy_sqlfmt-0.31.0.tar.gz"
    sha256 "229306cc1f3a4b38987bd298e2c51029dddd50783629adcd625fe7feb515cde6"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/00/21/39a76b01bd5eea82a04baaca7580e105d8c59450df03998345bb2cfb307b/textual-8.2.8.tar.gz"
    sha256 "3f106a9fbc73e39dd266c9712432087de78a6d644084c7c241d6a25c3169115b"
  end

  resource "textual-fastdatatable" do
    url "https://files.pythonhosted.org/packages/82/2a/f5844539d1ab139a220ee29ca81552cdd3e794048456a4b23a714f868e11/textual_fastdatatable-0.17.0.tar.gz"
    sha256 "3b1ea1f78aa7aa7ab41df9fb2b3b926fb274bbe8cb2e4f622b16a500eeb2157c"
  end

  resource "textual-textarea" do
    url "https://files.pythonhosted.org/packages/5b/e4/aa225ac619c07149b18864a240fd8cc6a710e8ffc01028bafa0059ace893/textual_textarea-0.18.1.tar.gz"
    sha256 "9db53da7659883cd905e66eabae11943c5b2e3a7530873ff85ee35d4bc3d928d"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/cc/18/0bbf3884e9eaa38819ebe46a7bd25dcd56b67434402b66a58c4b8e552575/tomlkit-0.13.3.tar.gz"
    sha256 "430cf247ee57df2b94ee3fbe588e71d362a941ebb545dec29b53961d61add2a1"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/21/3b/6c24bec5be5e743ffd99576daa5cc077722fc7d5bbc00bd133fa0c698dc6/tqdm-4.70.0.tar.gz"
    sha256 "55b0b0dbd97462d06ebee91e4dac24ed4d4702be82b24f07e6c1d27e08cea220"
  end

  resource "tree-sitter" do
    url "https://files.pythonhosted.org/packages/f7/03/5600b84aff2e6c4fe80cfebb4063fe2f50299521befe5f6092ab8c082f4a/tree_sitter-0.26.0.tar.gz"
    sha256 "b40c219edccc4564530c96f8f1556f6202b37cda964d1cbd7bd2b7e68b40a245"
  end

  resource "tree-sitter-bash" do
    url "https://files.pythonhosted.org/packages/8e/0e/f0108be910f1eef6499eabce517e79fe3b12057280ed398da67ce2426cba/tree_sitter_bash-0.25.1.tar.gz"
    sha256 "bfc0bdaa77bc1e86e3c6652e5a6e140c40c0a16b84185c2b63ad7cd809b88f14"
  end

  resource "tree-sitter-css" do
    url "https://files.pythonhosted.org/packages/38/37/7d60171240d4c5ba330f05b725dfb5e5fd5b7cbe0aa98ef9e77f77f868f5/tree_sitter_css-0.25.0.tar.gz"
    sha256 "2fc996bf05b04e06061e88ee4c60837783dc4e62a695205acbc262ee30454138"
  end

  resource "tree-sitter-go" do
    url "https://files.pythonhosted.org/packages/01/05/727308adbbc79bcb1c92fc0ea10556a735f9d0f0a5435a18f59d40f7fd77/tree_sitter_go-0.25.0.tar.gz"
    sha256 "a7466e9b8d94dda94cae8d91629f26edb2d26166fd454d4831c3bf6dfa2e8d68"
  end

  resource "tree-sitter-html" do
    url "https://ghfast.top/https://github.com/tree-sitter/tree-sitter-html/archive/refs/tags/v0.23.2.tar.gz"
    sha256 "21fa4f2d4dcb890ef12d09f4979a0007814f67f1c7294a9b17b0108a09e45ef7"
  end

  resource "tree-sitter-java" do
    url "https://ghfast.top/https://github.com/tree-sitter/tree-sitter-java/archive/refs/tags/v0.23.5.tar.gz"
    sha256 "cb199e0faae4b2c08425f88cbb51c1a9319612e7b96315a174a624db9bf3d9f0"
  end

  resource "tree-sitter-javascript" do
    url "https://files.pythonhosted.org/packages/59/e0/e63103c72a9d3dfd89a31e02e660263ad84b7438e5f44ee82e443e65bbde/tree_sitter_javascript-0.25.0.tar.gz"
    sha256 "329b5414874f0588a98f1c291f1b28138286617aa907746ffe55adfdcf963f38"
  end

  resource "tree-sitter-json" do
    url "https://ghfast.top/https://github.com/tree-sitter/tree-sitter-json/archive/refs/tags/v0.24.8.tar.gz"
    sha256 "acf6e8362457e819ed8b613f2ad9a0e1b621a77556c296f3abea58f7880a9213"
  end

  resource "tree-sitter-markdown" do
    url "https://ghfast.top/https://github.com/tree-sitter-grammars/tree-sitter-markdown/archive/refs/tags/v0.5.1.tar.gz"
    sha256 "acaffe5a54b4890f1a082ad6b309b600b792e93fc6ee2903d022257d5b15e216"
  end

  resource "tree-sitter-python" do
    url "https://files.pythonhosted.org/packages/b8/8b/c992ff0e768cb6768d5c96234579bf8842b3a633db641455d86dd30d5dac/tree_sitter_python-0.25.0.tar.gz"
    sha256 "b13e090f725f5b9c86aa455a268553c65cadf325471ad5b65cd29cac8a1a68ac"
  end

  resource "tree-sitter-regex" do
    url "https://files.pythonhosted.org/packages/86/92/1767b833518d731b97c07cf616ea15495dcc0af584aa0381657be4ec446d/tree_sitter_regex-0.25.0.tar.gz"
    sha256 "5d29111b3f27d4afb31496476d392d1f562fe0bfe954e8968f1d8683424fc331"
  end

  resource "tree-sitter-rust" do
    url "https://ghfast.top/https://github.com/tree-sitter/tree-sitter-rust/archive/refs/tags/v0.24.2.tar.gz"
    sha256 "061e90a539a55a6aa65dceb0ad6425c50ab1a6e3e6d4ba430e2795ed4550f10e"
  end

  resource "tree-sitter-sql" do
    url "https://files.pythonhosted.org/packages/e8/5c/3d10387f779f36835486167253682f61d5f4fd8336b7001da1ac7d78f31c/tree_sitter_sql-0.3.11.tar.gz"
    sha256 "700b93be2174c3c83d174ec3e10b682f72a4fb451f0076c7ce5012f1d5a76cbc"
  end

  resource "tree-sitter-toml" do
    url "https://ghfast.top/https://github.com/tree-sitter-grammars/tree-sitter-toml/archive/refs/tags/v0.7.0.tar.gz"
    sha256 "7d52a7d4884f307aabc872867c69084d94456d8afcdc63b0a73031a8b29036dc"
  end

  resource "tree-sitter-xml" do
    url "https://ghfast.top/https://github.com/tree-sitter-grammars/tree-sitter-xml/archive/refs/tags/v0.7.0.tar.gz"
    sha256 "4330a6b3685c2f66d108e1df0448eb40c468518c3a66f2c1607a924c262a3eb9"
  end

  resource "tree-sitter-yaml" do
    url "https://files.pythonhosted.org/packages/57/b6/941d356ac70c90b9d2927375259e3a4204f38f7499ec6e7e8a95b9664689/tree_sitter_yaml-0.7.2.tar.gz"
    sha256 "756db4c09c9d9e97c81699e8f941cb8ce4e51104927f6090eefe638ee567d32c"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/78/67/9a363818028526e2d4579334460df777115bdec1bb77c08f9db88f6389f2/uc_micro_py-2.0.0.tar.gz"
    sha256 "c53691e495c8db60e16ffc4861a35469b0ba0821fe409a8a7a0a71864d33a811"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/34/74/c6428f875774288bec1396f5bfcbc2d925700a4dad61727fd5f2b12f249d/wcwidth-0.8.2.tar.gz"
    sha256 "91fbef97204b96a3d4d421609b80340b760cf33e26da123ff243d76b1fda8dda"
  end

  def install
    virtualenv_install_with_resources
    generate_completions_from_executable(bin/"harlequin", shell_parameter_format: :click)
  end

  test do
    output = shell_output("#{bin}/harlequin --profile none 2>&1", 2)
    assert_match "Harlequin couldn't load your profile", output

    assert_match version.to_s, shell_output("#{bin}/harlequin --version")
  end
end