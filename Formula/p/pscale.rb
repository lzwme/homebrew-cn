class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https:www.planetscale.com"
  url "https:github.complanetscalecliarchiverefstagsv0.232.0.tar.gz"
  sha256 "7d38875051a115f056ca836095fc0301ac3ccba506b4edbc23d81428ba21f1d4"
  license "Apache-2.0"
  head "https:github.complanetscalecli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86d3adbb0cd964bed22668c3394af7ed02c9db9f61fdffd552048820f090e42a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41c66fce7f3216ea815389a42329623be11f8251fd855d5e82ffaa497e65dc19"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a92f0de2ef27e1acc56f4c0565a5ea4cd9d2e460e5cc9d40d84c6fce458c5beb"
    sha256 cellar: :any_skip_relocation, sonoma:        "c309a00f617078d646c78478395649972f83845d5391fa21d8aa0bb6a3b494c3"
    sha256 cellar: :any_skip_relocation, ventura:       "35b301a33116406486aff3aa69fa594c27d6333f0231ea460472e46566e92742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0bed2f931d0ff22ccd5ae9a23aa0341572807241b1fef82e8564a60e5e1503e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), ".cmdpscale"

    generate_completions_from_executable(bin"pscale", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}pscale org list 2>&1", 2)
  end
end