class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https:github.comdigitaloceandoctl"
  url "https:github.comdigitaloceandoctlarchiverefstagsv1.109.1.tar.gz"
  sha256 "ac1c94814283e090240534f9465be7e2213c3e7952108ec0da5f6cb3ad343c98"
  license "Apache-2.0"
  head "https:github.comdigitaloceandoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e5de52dca0264075b5f0ef36faf7bf8c95bf55cdaf78572e1852fd8b67413b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9aed8bc862f7e74418f68a8ac302dcca294ab9ad4a51b20c9421b4d052881571"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed907e09f6bc47bcf8161e4611abb4d0a58cd91c8908eb3f7ecd86bb1714f59f"
    sha256 cellar: :any_skip_relocation, sonoma:         "774910d2caa2a56d89cd06bd1e1316e54e392862bdf72cebcb5ac3810227f03a"
    sha256 cellar: :any_skip_relocation, ventura:        "3824bf0af429601529c5f1f311d1b0e3288f313cb5880870d951402da65337c3"
    sha256 cellar: :any_skip_relocation, monterey:       "73f2cfcc4053a30fc154540668c26b5303291716dfe50fc411a31a4cf1fea923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d405005240da8eb589032176f2724abc10b29b524ecb74034278717fd49eea6d"
  end

  depends_on "go" => :build

  def install
    base_flag = "-X github.comdigitaloceandoctl"
    ldflags = %W[
      #{base_flag}.Major=#{version.major}
      #{base_flag}.Minor=#{version.minor}
      #{base_flag}.Patch=#{version.patch}
      #{base_flag}.Label=release
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmddoctl"

    generate_completions_from_executable(bin"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}doctl version")
  end
end