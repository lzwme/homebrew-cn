class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.126.0.tar.gz"
  sha256 "a0354ba1bb1f1d92006e6519b17fcd3ede09eaa803f82162aa835690e52b8125"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab401c7294d5ee4c1f56dea863e6b8bc157586439b6348eec30f4f18dc1e67cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6daaaac30516b2c862e49df74653d5c465b488cc0b7fc9717bb02b6f0fd90679"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96be8a4334f8b8d5bb4db0d610a1b1ad892b92a6c236478c78ba2a8c06af1d89"
    sha256 cellar: :any_skip_relocation, sonoma:         "ddee8dfb0036cd8494d770a7f2044bfd9039652a07f726ca76e80e62feabbb46"
    sha256 cellar: :any_skip_relocation, ventura:        "1922dd128a3f49ea61750b5e2ed254a67da7252fcd19487aa533750fd9128dde"
    sha256 cellar: :any_skip_relocation, monterey:       "2b12a2e516ce80757da7298d268932d50a09ac891699cd0b6d1c513e36136b32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ca75c2555e5084e62c7aec22d8fff78c2cb0834554a8c2158b5c05bfd0ad279"
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