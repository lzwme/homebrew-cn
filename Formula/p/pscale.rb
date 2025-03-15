class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https:www.planetscale.com"
  url "https:github.complanetscalecliarchiverefstagsv0.230.0.tar.gz"
  sha256 "7fea5568e85af13944dff4960d62af5d7f9c812a760dffd1518736d4f67d5a2f"
  license "Apache-2.0"
  head "https:github.complanetscalecli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cd7446de3aba0e5a3986fbc48f004ce5d1686685d57213ab30c044ead445c7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "477c8e8d8bcb0851c26b8074934448279b45a089a868e5b359dad0d754e3c2cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72fedb3741d59a5de0b026e07c4a02c44ce339ba9b9b43a4fcac3edd52068ffc"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1487bec37f0fdab80e45f0e94f67a24c8fd7952fcf47fb545c5a42661076257"
    sha256 cellar: :any_skip_relocation, ventura:       "371cfc5ce888d9fd61136cc15765188c791d0a4aa8dfcd3e3877e7ae7cfbb0e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5a3b54d3917485090312e00727d96c919c1716fab01eb1e2788f96685f690d9"
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