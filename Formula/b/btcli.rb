class Btcli < Formula
  include Language::Python::Virtualenv

  desc "Bittensor command-line tool"
  homepage "https://docs.bittensor.com/btcli"
  url "https://files.pythonhosted.org/packages/35/8d/18b67fde1bf5c109f60b15e084e38221533814698f46134870e9b217ad51/bittensor_cli-9.22.0.tar.gz"
  sha256 "d289e098ad32e5ff5fba7a6d8d5f709ec2d971e4b87e0b9d75962ee1b5407068"
  license "MIT"
  head "https://github.com/opentensor/btcli.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "657a845c40fc64a93127f6911bf8d8ebc21aebb51ebd1dc202718679d5ee3e9d"
    sha256 cellar: :any, arm64_sequoia: "b39206f3f470501852a4ecd673d72d7c54f9f1057dc87bf1c8b074933fb4a2cb"
    sha256 cellar: :any, arm64_sonoma:  "4f398c3869bef6ce0fd4e5a96c1b061c243febf2cbd5ca1db0b8f06179ed8bf6"
    sha256 cellar: :any, sonoma:        "ac9d86dc9b2c14a46f91f1f899b6bbd77930358884cbf198b18c0c70883165d7"
    sha256 cellar: :any, arm64_linux:   "765d0e7a600d5b26b1dae07cc255d72998233e534d97536f986342507c8c194e"
    sha256 cellar: :any, x86_64_linux:  "03a4a59ec46a826fce25adf80d3e59970b03c2dd5c33f423d32bf4fe483eb5fd"
  end

  depends_on "rust" => :build # for bittensor-wallet, plotly

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "openssl@3"
  depends_on "python@3.14"

  conflicts_with "btpd", because: "both install `btcli` binaries"

  pypi_packages exclude_packages: %w[certifi numpy]

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/33/c6/61a2d7b7572279226bb2e7f61d7a19ca7c90da0329c93fa0d560cbf288d8/aiohappyeyeballs-2.6.2.tar.gz"
    sha256 "e202810ee718bd01fc6ef49e8ea53d023d5cb6b581076d7925aa499fa55dbe64"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/77/9a/152096d4808df8e4268befa55fba462f440f14beab85e8ad9bf990516918/aiohttp-3.13.5.tar.gz"
    sha256 "9d98cc980ecc96be6eb4c1994ce35d28d8b1f5e5208a23b421187d1209dbb7d1"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "aiosqlite" do
    url "https://files.pythonhosted.org/packages/4e/8a/64761f4005f17809769d23e518d915db74e6310474e733e3593cfc854ef1/aiosqlite-0.22.1.tar.gz"
    sha256 "043e0bd78d32888c0a9ca90fc788b38796843360c855a7262a532813133a0650"
  end

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "async-substrate-interface" do
    url "https://files.pythonhosted.org/packages/00/05/a7c693b274dbf8c6ed2ceb6b38afe9e78e1dbec36b9d5a2e622cd9104a81/async_substrate_interface-2.0.4.tar.gz"
    sha256 "6c686a035059b6922e2a3372a62ddf54484fa117fde5d6741d1aeb3e01f67117"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "bittensor-drand" do
    url "https://files.pythonhosted.org/packages/36/13/36a587abc84cfa5a855879e247c3a763fe05cae02ff007f71f895ec933e2/bittensor_drand-1.3.0.tar.gz"
    sha256 "ec3694c2226d66e2637168c8b31082d5cbbf991e350c254e340e1eb0255142fd"
  end

  resource "bittensor-wallet" do
    url "https://files.pythonhosted.org/packages/a0/30/7eb06cfd5d901d2cd3760a8b85d66c7b84f96f03d6d0402b306fdf8b6a2d/bittensor_wallet-4.1.0.tar.gz"
    sha256 "f0f34641a4b9110def9e35fe22498195fcb31d143dc4f76dd9022db374ccd484"
  end

  resource "cyscale" do
    url "https://files.pythonhosted.org/packages/41/71/8d6682ce88a8b1f02ebdfc658fc16d36dabfebe17eb0d7a743fbf0f2cb2b/cyscale-0.4.0.tar.gz"
    sha256 "0ca5ad331a99e86b944876ef2c45962d0a4ae7e915374fd8d8f6b7c0a3779028"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/33/f6/354ae6491228b5eb40e10d89c4d13c651fe1cf7556e35ebdded50cff57ce/gitpython-3.1.50.tar.gz"
    sha256 "80da2d12504d52e1f998772dc5baf6e553f8d2fcfe1fcc226c9d9a2ee3372dcc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/b9/28/99c51f664567218d824af024c0251650fb27e4ca066df188dab0769c5b91/idna-3.17.tar.gz"
    sha256 "5eb0cb53bc467c12eadcf6de83163ad8527cec9416f44b9b61b19caedad2b87f"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
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

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/1a/c2/c2d94cbe6ac1753f3fc980da97b3d930efe1da3af3c9f5125354436c073d/multidict-6.7.1.tar.gz"
    sha256 "ec6652a1bee61c53a3e5776b6049172c53b6aaba34f18c9ad04f82712bac623d"
  end

  resource "narwhals" do
    url "https://files.pythonhosted.org/packages/cf/a0/6198c56d42ef2f3c6ed0c42ba30dbcefdc86a91262d7d449010770ae085b/narwhals-2.21.2.tar.gz"
    sha256 "5c5b2d0b47aef7c73ea412cfcbcd467f2f2d5be73e3c2ab19d78f4a97718790a"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/54/90/188b2a69654f27b221fba92fda7217778208532c962509e959a9cee5229d/netaddr-1.3.0.tar.gz"
    sha256 "5c3c3d9895b551b763779ba7db7a03487dc1f8e3b385af819af341ae9ef6e48a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "plotille" do
    url "https://files.pythonhosted.org/packages/46/51/a6093145179139e7dffc01aa499b0169c91154a743197a3fd16252a9e90d/plotille-6.0.5.tar.gz"
    sha256 "26d2cef5d4feb8632c9710442ad49fc57f9d5b20881c21ac7954c76208b5600b"
  end

  resource "plotly" do
    url "https://files.pythonhosted.org/packages/3a/7f/0f100df1172aadf88a929a9dbb902656b0880ba4b960fe5224867159d8f4/plotly-6.7.0.tar.gz"
    sha256 "45eea0ff27e2a23ccd62776f77eb43aa1ca03df4192b76036e380bb479b892c6"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/ec/44/c87281c333769159c50594f22610f77398a47ccbfbbf23074e744e86f87c/propcache-0.5.2.tar.gz"
    sha256 "01c4fc7480cd0598bb4b57022df55b9ca296da7fc5a8760bd8451a7e63a7d427"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/1f/ea/49c993d6dfdd7338c9b1000a0f36817ed7ec84577ae2e52f890d1a4ff909/smmap-5.0.3.tar.gz"
    sha256 "4d9debb8b99007ae47165abc08670bd74cb74b5227dda7f643eccc4e9eb5642c"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/cc/15/f5fc7be23b7196bc065b282d9589a372392fb10860c80f9c1dd7eb008662/typer-0.26.3.tar.gz"
    sha256 "3e2b9352f535e5303ef27806dadc2c8647687bdca5c902f03fec3fb88f46a46a"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/04/24/4b2031d72e840ce4c1ccb255f693b15c334757fc50023e4db9537080b8c4/websockets-16.0.tar.gz"
    sha256 "5f6261a5e56e8d5c42a4497b364ea24d94d9563e8fbd44e78ac40879c60179b5"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/39/62/75f18a0f03b4219c456652c7780e4d749b929eb605c098ce3a5b6b6bc081/wheel-0.47.0.tar.gz"
    sha256 "cc72bd1009ba0cf63922e28f94d9d83b920aa2bb28f798a31d0691b02fa3c9b3"
  end

  resource "xxhash" do
    url "https://files.pythonhosted.org/packages/24/2f/e183a1b407002f5af81822bee18b61cdb94b8670208ef34734d8d2b8ebe9/xxhash-3.7.0.tar.gz"
    sha256 "6cc4eefbb542a5d6ffd6d70ea9c502957c925e800f998c5630ecc809d6702bae"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/79/12/1e8f37460ea0f7eb59c221fdaf0ed75e7ac43e97f8093b9c6f411df50a78/yarl-1.24.2.tar.gz"
    sha256 "9ac374123c6fd7abf64d1fec93962b0bd4ee2c19751755a762a72dd96c0378f8"
  end

  def install
    ENV.O0
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"btcli", shell_parameter_format: :typer)
  end

  test do
    require "json"
    wallet_path = testpath/"btcli-brew-test"
    test_wallet_name = "brew-test"
    ss58_address = "5FHneW46xGXgs5mUiveU4sbTyGBzmstUspZC92UhjJM694ty"

    # Create wallet
    create_args = %W[
      --wallet-name #{test_wallet_name}
      --wallet-path #{wallet_path}
      --hotkey default
      --no-use-password
      --uri Bob
      --overwrite
      --json-output
    ]
    output = shell_output("#{bin}/btcli w create #{create_args.join(" ")}")

    expected_create = {
      "success" => true,
      "error"   => "",
      "data"    =>
                   {
                     "name"         => test_wallet_name,
                     "path"         => wallet_path.to_s,
                     "hotkey"       => "default",
                     "hotkey_ss58"  => ss58_address,
                     "coldkey_ss58" => ss58_address,
                   },
    }

    parsed_create = JSON.parse(output)
    assert_equal expected_create, parsed_create

    # Check balance of the created wallet on the finney network
    balance_args = %W[
      --network finney
      --wallet-path #{wallet_path}
      --wallet-name #{test_wallet_name}
      --json-output
    ]
    balance_output = shell_output("#{bin}/btcli w balance #{balance_args.join(" ")}")

    expected_balance = {
      "balances" => {
        "brew-test" => {
          "coldkey" => ss58_address,
          "free"    => 0.0,
          "staked"  => 0.0,
          "total"   => 0.0,
        },
      },
      "totals"   => {
        "free"   => 0.0,
        "staked" => 0.0,
        "total"  => 0.0,
      },
    }

    parsed_balance = JSON.parse(balance_output)
    assert_equal expected_balance, parsed_balance
  end
end