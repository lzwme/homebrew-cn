require "languagego"

class GxGo < Formula
  desc "Tool to use with the gx package manager for packages written in go"
  homepage "https:github.comwhyrusleepinggx-go"
  url "https:github.comwhyrusleepinggx-goarchiverefstagsv1.9.0.tar.gz"
  sha256 "f3a0ee17359e0e5efab8008361da0e312ca723a0c9e165342a0306caba55a535"
  license "MIT"
  head "https:github.comwhyrusleepinggx-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9c7ca000510ef160dc187f094090bb53c2a8abe7148429b05e84092e0733d53"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "558cc3380d5004e4dc70927523f0900d89b11441aa75439049ef04317cde5606"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be5396fc6d5a6908b2a41a321dd7aa4f87d78ffb656bf54a14869fb4cb1e51d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f19c6b08f918f3a5d697033421405cc1d8640251c1f35debc5c64a68638a6bf6"
    sha256 cellar: :any_skip_relocation, sonoma:         "b56120d4f18db189ffe6f0b0bf9999311ff388cb363cb3278b4b6a7d7e9cd53b"
    sha256 cellar: :any_skip_relocation, ventura:        "4f9b488b986e19ba22109848419684a6f933abb46881a957c90d07cab701201e"
    sha256 cellar: :any_skip_relocation, monterey:       "ce75606c2944f263c2cf7b83930c1cd3ce57fd6dce50be5ba37b8d074e86c8eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "5dc1b0036572c7bd56d60b294608b151f1740018d90b94034072d8a97f3c0368"
    sha256 cellar: :any_skip_relocation, catalina:       "66fa3b40ddb24acbb713379c90df9b398baafd51aa825d5ba28d5fc7781ad987"
    sha256 cellar: :any_skip_relocation, mojave:         "8c86c8465cde5c6189e67f2d3b758604ef579d064f398cd48eff6ab6ce092bdb"
    sha256 cellar: :any_skip_relocation, high_sierra:    "57eb4c948ce99ebca79f938539c1b5e096aef6c16554c30f5744b4e1fc93016d"
    sha256 cellar: :any_skip_relocation, sierra:         "7eb7a89b575a1cb12464f1a0a4d14c5983333a79fb6e4fbb9c5b5240e540020d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "692e3553ebcc2909c27897f5fc6c74a7937af1e8cee2819daab8c6573e0bf8b5"
  end

  # https:github.comwhyrusleepinggx-goissues63
  deprecate! date: "2023-06-27", because: :unmaintained

  depends_on "go" => :build

  go_resource "github.comagled25519" do
    url "https:github.comagled25519.git",
        revision: "5312a61534124124185d41f09206b9fef1d88403"
  end

  go_resource "github.combtcsuitebtcd" do
    url "https:github.combtcsuitebtcd.git",
        revision: "675abc5df3c5531bc741b56a765e35623459da6d"
  end

  go_resource "github.comurfavecli" do
    url "https:github.comurfavecli.git",
        revision: "cfb38830724cc34fedffe9a2a29fb54fa9169cd1"
  end

  go_resource "github.comgogoprotobuf" do
    url "https:github.comgogoprotobuf.git",
        revision: "ba06b47c162d49f2af050fb4c75bcbc86a159d5c"
  end

  go_resource "github.comgxedhashland" do
    url "https:github.comgxedhashland.git",
        revision: "d9f6b97f8db22dd1e090fd0bbbe98f09cc7dd0a8"
  end

  go_resource "github.comipfsgo-ipfs-api" do
    url "https:github.comipfsgo-ipfs-api.git",
        revision: "d204576299ddab1140d043d0abb0d9b60a8a5af4"
  end

  go_resource "github.comipfsgo-ipfs-cmdkit" do
    url "https:github.comipfsgo-ipfs-cmdkit.git",
        revision: "c2103d7ae7f889e7329673cc3ba55df8b3863b0f"
  end

  go_resource "github.comipfsgo-log" do
    url "https:github.comipfsgo-log.git",
        revision: "0ef81702b797a2ecef05f45dcc82b15298f54355"
  end

  go_resource "github.comkrfs" do
    url "https:github.comkrfs.git",
        revision: "1455def202f6e05b95cc7bfc7e8ae67ae5141eba"
  end

  go_resource "github.comlibp2pgo-libp2p-crypto" do
    url "https:github.comlibp2pgo-libp2p-crypto.git",
        revision: "18915b5467c77ad8c07a35328c2cab468667a4e8"
  end

  go_resource "github.comlibp2pgo-libp2p-peer" do
    url "https:github.comlibp2pgo-libp2p-peer.git",
        revision: "aa0e03e559bde9d4749ad8e38595e15a6fe808fa"
  end

  go_resource "github.comlibp2pgo-libp2p-pubsub" do
    url "https:github.comlibp2pgo-libp2p-pubsub.git",
        revision: "f736644fe805a9f5677c82aca25c82da7cde2c76"
  end

  go_resource "github.commattngo-colorable" do
    url "https:github.commattngo-colorable.git",
        revision: "efa589957cd060542a26d2dd7832fd6a6c6c3ade"
  end

  go_resource "github.commattngo-isatty" do
    url "https:github.commattngo-isatty.git",
        revision: "6ca4dbf54d38eea1a992b3c722a76a5d1c4cb25c"
  end

  go_resource "github.comminioblake2b-simd" do
    url "https:github.comminioblake2b-simd.git",
        revision: "3f5f724cb5b182a5c278d6d3d55b40e7f8c2efb4"
  end

  go_resource "github.comminiosha256-simd" do
    url "https:github.comminiosha256-simd.git",
        revision: "ad98a36ba0da87206e3378c556abbfeaeaa98668"
  end

  go_resource "github.commitchellhgo-homedir" do
    url "https:github.commitchellhgo-homedir.git",
        revision: "b8bc1bf767474819792c23f32d8286a45736f1c6"
  end

  go_resource "github.commr-tronbase58" do
    url "https:github.commr-tronbase58.git",
        revision: "c1bdf7c52f59d6685ca597b9955a443ff95eeee6"
  end

  go_resource "github.commultiformatsgo-multiaddr" do
    url "https:github.commultiformatsgo-multiaddr.git",
        revision: "123a717755e0559ec8fda308019cd24e0a37bb07"
  end

  go_resource "github.commultiformatsgo-multiaddr-net" do
    url "https:github.commultiformatsgo-multiaddr-net.git",
        revision: "97d80565f68c5df715e6ba59c2f6a03d1fc33aaf"
  end

  go_resource "github.commultiformatsgo-multihash" do
    url "https:github.commultiformatsgo-multihash.git",
        revision: "265e72146e710ff649c6982e3699d01d4e9a18bb"
  end

  go_resource "github.comopentracingopentracing-go" do
    url "https:github.comopentracingopentracing-go.git",
        revision: "6c572c00d1830223701e155de97408483dfcd14a"
  end

  go_resource "github.comsabhiramgo-gitignore" do
    url "https:github.comsabhiramgo-gitignore.git",
        revision: "fc6676d5d4e5b94d6530686eecb94f85b44cdc39"
  end

  go_resource "github.comspaolaccimurmur3" do
    url "https:github.comspaolaccimurmur3.git",
        revision: "f09979ecbc725b9e6d41a297405f65e7e8804acc"
  end

  go_resource "github.comwhyrusleepinggo-logging" do
    url "https:github.comwhyrusleepinggo-logging.git",
        revision: "0457bb6b88fc1973573aaf6b5145d8d3ae972390"
  end

  go_resource "github.comwhyrusleepinggx" do
    url "https:github.comwhyrusleepinggx.git",
        revision: "733691bc18c0858a3d7e1a6e0a42df7d0bcac1de"
  end

  go_resource "github.comwhyrusleepingprogmeter" do
    url "https:github.comwhyrusleepingprogmeter.git",
        revision: "30d42a105341e640d284d9920da2078029764980"
  end

  go_resource "github.comwhyrusleepingstump" do
    url "https:github.comwhyrusleepingstump.git",
        revision: "206f8f13aae1697a6fc1f4a55799faf955971fc5"
  end

  go_resource "github.comwhyrusleepingtar-utils" do
    url "https:github.comwhyrusleepingtar-utils.git",
        revision: "8c6c8ba81d5c71fd69c0f48dbde4b2fb422b6dfc"
  end

  go_resource "golang.orgxcrypto" do
    url "https:go.googlesource.comcrypto.git",
        revision: "2d027ae1dddd4694d54f7a8b6cbe78dca8720226"
  end

  go_resource "golang.orgxsys" do
    url "https:go.googlesource.comsys.git",
        revision: "d0faeb539838e250bd0a9db4182d48d4a1915181"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    mkdir_p "srcgithub.comwhyrusleeping"
    ln_s buildpath, "srcgithub.comwhyrusleepinggx-go"
    Language::Go.stage_deps resources, buildpath"src"
    system "go", "build", "-o", bin"gx-go"
  end

  test do
    system bin"gx-go", "help"
  end
end