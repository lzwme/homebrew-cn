class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.128.2.tar.gz"
  sha256 "8efceadfa75c54456c2f794af05a3f9d1fbda559a4283d44e8b277b7fb6e008b"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2bf1468ea3814b1286a5558674a79701ba44577ecc07d37bf232b3b8d8d0826b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a723521292d8ccbb18cb51235f22f472c8051e1091da7f4e27a63a332fe6f944"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d05bfc2972686ef62829456034b878dfbd4fc5a55ff84d9e8c8305ba2c8bac5"
    sha256 cellar: :any_skip_relocation, sonoma:         "088ad8a8f25ad0c190510116b8b60c0721ad0de5292b5169bbe52764c88cfb5c"
    sha256 cellar: :any_skip_relocation, ventura:        "3b5ca4bd267dc4dacef173c37b4f2b6bcccf2cff31a44a8058d893fa3691dec3"
    sha256 cellar: :any_skip_relocation, monterey:       "ad00c86c8133416f762e2f07804a4f39d0f3db1052851f468bd8b994c38d8153"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "874d920ce97119437f6df0b5977544be83c952186e123b8601f5fede6d8094a7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgohugoiohugocommonhugo.commitHash=#{tap.user}
      -X github.comgohugoiohugocommonhugo.buildDate=#{time.iso8601}
      -X github.comgohugoiohugocommonhugo.vendorInfo=brew
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "extended"

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