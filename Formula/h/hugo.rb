class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.133.1.tar.gz"
  sha256 "36bc419ed33b9a2accfbb2c947c261002a25f7b1bfad7c42a7874247e7bf1688"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5368b0deeb9e69d432c9fea723fa8ad8063d977e6a4eb305f1c63f76fde3349"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e088c3c2868f2635384edd653fa413d67ae7f1d5b1015a22eaf3f994b8e6045e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a94b4d663bff0ad47925186d11f3787cb126d1f6dd5b69c66587b23b0dcf71ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e1fe10219b2945af87001802cc5f32eae8254e6d38801734cdade4242ff49f8"
    sha256 cellar: :any_skip_relocation, ventura:        "e1a97b525e66a995d7d3a979b9ccc9e638a8a1daefcfbd92116b35b27433705e"
    sha256 cellar: :any_skip_relocation, monterey:       "5f1c7e1394fcfd536f27a9afeb7c287b5dc9a6c5fbf886ea5244537133037e7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9bc4b773260edf94340c7c7a44dfc02e2e32993b29e046a2c4eb2e1a0a0e77b"
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