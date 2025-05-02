class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.147.1.tar.gz"
  sha256 "6a61ff3982f1c8b92e55f9d1f38d298420350d111ec1a31a9baee8f1b5a4f8db"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db4ebaee3c5820b137e711e9c1c0f280d4567c11c000476baff1b9e25b6c3067"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7a6d6361735a0b1aac21363b9ab5fb3220f48032ac3f825eeab7955c0e95664"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8bfc1041bdd62de1e815b2571b50911124ed3724ec24dbd37115986954aedf7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f74f177e8246bf8ff2cca556d185f0ff8ca0c43d46b97ad76b214dd0b73e510c"
    sha256 cellar: :any_skip_relocation, ventura:       "e97d88d811b08281d5c913f7464f803dae3f82b363445648bfe7032032c534e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ada95f4f22240bdc9c9cfae0384b7654b804309e19560dc5d5fce717c25d795a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ee467889feaf04677ce1daef3fe0ecd366e05c6e69088222089841b20b7df4f"
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