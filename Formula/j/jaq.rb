class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https:github.com01mf02jaq"
  url "https:github.com01mf02jaqarchiverefstagsv1.5.0.tar.gz"
  sha256 "318e9344a85e96b43acca2615c8d47b7e061f8ed4c664728a0b9528d7ac1782a"
  license "MIT"
  head "https:github.com01mf02jaq.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25a56e6606fee65ac12035aa9e41588c9b8ca0c346e2964b291eed2c03c662b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca3610f68f48b9cb5149a6d220abe7149ad2609ac79af8e3749284af0264d269"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1171f2cfdde180c9c714471e524caa6b0b9c14673f8f0df0f73f35f7a5da96c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d96f98aa913f94828049c58edd3d31187cf723714730d30e42d371842fa854c"
    sha256 cellar: :any_skip_relocation, ventura:        "36122825ab95be91320250c7fda727615efbbc141b7674433df7f50c1ebf0882"
    sha256 cellar: :any_skip_relocation, monterey:       "28542b2780bde296671cef0dea5751ff270539b08d5dc919cf57e272e012f785"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b12f932f1227cae10b0282fa2b2bb0da00f560fa04476a80da0b3dfe62b5412e"
  end

  depends_on "rust" => :build

  conflicts_with "json2tsv", because: "both install `jaq` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "jaq")
  end

  test do
    assert_match "1", shell_output("echo '{\"a\": 1, \"b\": 2}' | #{bin}jaq '.a'")
    assert_match "2.5", shell_output("echo '1 2 3 4' | #{bin}jaq -s 'add  length'")
  end
end