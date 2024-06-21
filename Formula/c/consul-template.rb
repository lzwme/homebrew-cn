class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https:github.comhashicorpconsul-template"
  url "https:github.comhashicorpconsul-templatearchiverefstagsv0.39.0.tar.gz"
  sha256 "46947663a3e884ee2c8907d6b2f46ee54288f18099842bdb02bcfe3cfa553398"
  license "MPL-2.0"
  head "https:github.comhashicorpconsul-template.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "780ce1c2eb1c7707c4975595fc1ad54815991fbf8c1c99f36362fa5522c19d9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9279a6f5f535de3fea366a87d03dd32761e88469685beac29654e17767949849"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d747dca8fcb4201ad82ed168a58d0cfc35417f2733b278f91efb63ea7c6e037"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e5e80f64cfcc7334cd850b1462feff4a147f3804b23c934d45e527f4b362290"
    sha256 cellar: :any_skip_relocation, ventura:        "65fceb18010734283924256c503723cfb95dde97af61d3124a37eb25f47080fa"
    sha256 cellar: :any_skip_relocation, monterey:       "0b689c069dde04af66f106ff919bcf0c2fd5a9931c625db15213ae868e6e8c56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76ae0010dcd1622e4430a2e85a19970ccde716490f83d738f909fdcfd592a861"
  end

  depends_on "go" => :build

  def install
    project = "github.comhashicorpconsul-template"
    ldflags = %W[
      -s -w
      -X #{project}version.Name=consul-template
      -X #{project}version.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
    prefix.install_metafiles
  end

  test do
    (testpath"template").write <<~EOS
      {{"homebrew" | toTitle}}
    EOS
    system bin"consul-template", "-once", "-template", "template:test-result"
    assert_equal "Homebrew", (testpath"test-result").read.chomp
  end
end