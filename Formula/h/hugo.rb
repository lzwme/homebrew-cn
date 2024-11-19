class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.139.0.tar.gz"
  sha256 "4eeba2c3f993d05267d604eca2a5929a090663c437a1585c0607bfcfaa5a8c95"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1004045903897caa98b450e1c8a188492f5b49d443df2895813f8acabc5afa8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3879187e43791f5dd903a8d2dcf86797a35acaca7622b4a47ad0174d4edb2dee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d70b9e50551b568776597971aa3a804651a130f1231fb7b9de5df636f31ce08"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c81361df92d7c8690420d8b4c60a32b11c06f53f4544444a95aafe2e0f99582"
    sha256 cellar: :any_skip_relocation, ventura:       "0ef54c8ecbddc1aab146acf3527712d18c251c6d8812835dab1bb88496e97a7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2e84d02e8553220e55ac7ff9a44cc95a7c48cd39416a66d432f5f6c007494da"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgohugoiohugocommonhugo.commitHash=#{tap.user}
      -X github.comgohugoiohugocommonhugo.buildDate=#{time.iso8601}
      -X github.comgohugoiohugocommonhugo.vendorInfo=brew
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "extended,withdeploy"

    generate_completions_from_executable(bin"hugo", "completion")
    system bin"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath"hops-yeast-malt-water"
    system bin"hugo", "new", "site", site
    assert_predicate site"hugo.toml", :exist?

    assert_match version.to_s, shell_output(bin"hugo version")
  end
end