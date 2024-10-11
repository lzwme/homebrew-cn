class Remarshal < Formula
  include Language::Python::Virtualenv

  desc "Convert between TOML, YAML and JSON"
  homepage "https:github.comremarshal-projectremarshal"
  url "https:files.pythonhosted.orgpackagesaee798e22a9d62ee2c086da94f6aafeee5e7c3a68197d761cc22c90e7e949afbremarshal-0.18.0.tar.gz"
  sha256 "8fd29ba9d5931f5ee2c54f902b11b26cd3bbca0ad8b3d6f39ca48255284f71dd"
  license "MIT"
  head "https:github.comremarshal-projectremarshal.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbb59f67b559e23f1f753d59ed14abe4480629c2ecd136956a629b070068dc5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a37f7612a8aff3ecfa898545a4378c30a663f6ddbb057b8edde10ab09386e902"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b85a726195027c768025551799b5caf18204f15c1df77b42919187283ea953a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6f20ac0594ce4a0ab1e75ebca41114eaf8c0cbc169900200a6c623c2f99651c"
    sha256 cellar: :any_skip_relocation, ventura:       "2419097e325c43da8ac103b72fb62a4aa5375d95ff1f8f2f34e5c895d4e71191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f96b4eb29477bf7e984652007a6301bf5e1dddd25c9e47bea5d8f2c36b49e86"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  conflicts_with "msgpack-tools", because: "both install 'json2msgpack' binary"

  resource "cbor2" do
    url "https:files.pythonhosted.orgpackagese4aaba55b47d51d27911981a18743b4d3cebfabccbb0598c09801b734cec4184cbor2-5.6.5.tar.gz"
    sha256 "b682820677ee1dbba45f7da11898d2720f92e06be36acec290867d5ebf3d7e09"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesaa9e1784d15b057b0075e5136445aaea92d23955aad2c93eaede673718a40d95rich-13.9.2.tar.gz"
    sha256 "51a2c62057461aaf7152b4d611168f93a9fc73068f8ded2790f29fe2b5366d0c"
  end

  resource "rich-argparse" do
    url "https:files.pythonhosted.orgpackages26f10a5ba24d684012e2f25deec88d9a9a1199d8e26e3bb595b812c8b0218cffrich_argparse-1.5.2.tar.gz"
    sha256 "84d348d5b6dafe99fffe2c7ea1ca0afe14096c921693445b9eee65ee4fcbfd2c"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackages29814dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
  end

  resource "tomlkit" do
    url "https:files.pythonhosted.orgpackages2bab18f4c8f2bec75eb1a7aebcc52cdb02ab04fd39ff7025bb1b1c7846cc45b8tomlkit-0.12.5.tar.gz"
    sha256 "eef34fba39834d4d6b73c9ba7f3e4d1c417a4e56f89a7e96e090dd0d24b8fb3c"
  end

  resource "u-msgpack-python" do
    url "https:files.pythonhosted.orgpackages369da40411a475e7d4838994b7f6bcc6bfca9acc5b119ce3a7503608c4428b49u-msgpack-python-2.8.0.tar.gz"
    sha256 "b801a83d6ed75e6df41e44518b4f2a9c221dc2da4bcd5380e3a0feda520bc61a"
  end

  def install
    # Work around ruamel.yaml.clib not building on Xcode 15.3, remove after a new release
    # has resolved: https:sourceforge.netpruamel-yaml-clibtickets32
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    virtualenv_install_with_resources
  end

  test do
    json = "{\"foo.bar\":\"baz\",\"qux\":1}"
    yaml = <<~EOS.chomp
      foo.bar: baz
      qux: 1

    EOS
    toml = <<~EOS.chomp
      "foo.bar" = "baz"
      qux = 1

    EOS
    assert_equal yaml, pipe_output("#{bin}remarshal -if=json -of=yaml", json)
    assert_equal yaml, pipe_output("#{bin}json2yaml", json)
    assert_equal toml, pipe_output("#{bin}remarshal -if=yaml -of=toml", yaml)
    assert_equal toml, pipe_output("#{bin}yaml2toml", yaml)
    assert_equal json, pipe_output("#{bin}remarshal -if=toml -of=json", toml).chomp
    assert_equal json, pipe_output("#{bin}toml2json", toml).chomp
    assert_equal pipe_output("#{bin}remarshal -if=yaml -of=msgpack", yaml),
      pipe_output("#{bin}remarshal -if=json -of=msgpack", json)

    assert_match version.to_s, shell_output("#{bin}remarshal --version")
  end
end