class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.146.5.tar.gz"
  sha256 "7f9aab1fe0655b7ffccd422ec8ca4df4a0df3830be9794479a3a272f77c24929"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9c85b8e0c70a144ade5ebaf574e26f3f17e457e9e54b444ae69f0d3d5f4294e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9e25e8fdc57f1fb32dee7133ad9353010922e3222dcc64617bfba0d40ad5b3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7644daee67849d8587fdb37fbfe1e2207f55c419e93fa191cc79b07c06aac7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "615e9adca7bf21675dca108b4be5c83117e5ffab0a30e00a47f7574419475d07"
    sha256 cellar: :any_skip_relocation, ventura:       "1633a4e89ea47121113ee5a7887d45d725ac6133e1b30349bb087e26f332f6d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6355d73e2f192c4e65331c628a75d58ad7eb2bd7244862962b56c0b8a88f453"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "555f8ab7153af5c1e968815fc80f153f366b66ecdbee5934693d80774bbd20d9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgohugoiohugocommonhugo.commitHash=#{tap.user}
      -X github.comgohugoiohugocommonhugo.buildDate=#{time.iso8601}
      -X github.comgohugoiohugocommonhugo.vendorInfo=brew
    ]
    tags = %w[extended withdeploy]
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin"hugo", "completion")
    system bin"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath"hops-yeast-malt-water"
    system bin"hugo", "new", "site", site
    assert_path_exists site"hugo.toml"

    assert_match version.to_s, shell_output(bin"hugo version")
  end
end