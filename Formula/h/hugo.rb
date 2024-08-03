class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.131.0.tar.gz"
  sha256 "e72d8a4a90e2be8a73bb178a4e0135a1a2e2cd5c018d19fd886499715214143a"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbe14139f5f8b3878d69e0cee6339f1635823a0ec84f2832a279e87fce14bca7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59e43e20f3999829a2487ab693bab49af562ca7c563132f0de24fb928a736e31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4184c8c7005c784c82c83b7b5ba020ba99557ee51e75cf046b129bbba80a4e10"
    sha256 cellar: :any_skip_relocation, sonoma:         "1372dd39f3a0840832799dcf5ceb896d6e1ecf53d86da9da2b864066d3c6dc26"
    sha256 cellar: :any_skip_relocation, ventura:        "99aed9105957483eeb0df937c269e815bc2745a37f86514b958da170cef284b5"
    sha256 cellar: :any_skip_relocation, monterey:       "ead31c0c6c36096e4cbd2ddb96cf7379d340ecdc888202150fc3cd3b6d266a6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fad175279ee0074b0f58d058ea3050bd3f5a4c48ca0e62188915c078d82a5095"
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