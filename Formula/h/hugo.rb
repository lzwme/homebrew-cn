class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.138.0.tar.gz"
  sha256 "2527f9df57d872c2651ad8e8895c7256c7af9a58c73e5e72f5ba0ae9714cad8e"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cb0c749125a32f312af992aa34f1b48a9135ed50f32b13657d2476431601265"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46ee1485e8926af9d67089237c6f9600d39ff46c46d5bec14e89f5d81774e2ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c6fb1ace5effbfaa41c3b87ec7627324a90aadaa2474ef9e3cb38468db7b259"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9a1fdc7b6b5dc4abec65d06b590340bc4c9057b45bc5c16c84cbfb39ba06920"
    sha256 cellar: :any_skip_relocation, ventura:       "b167904e4eb2856d1967036121a989fe41edea9f856df9d37cf59ea991d2ab92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e3c6d9507f0b6311b0ad4c8e5bb480ec7e3cfafb91ab7e6e46407658fe8b13f"
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