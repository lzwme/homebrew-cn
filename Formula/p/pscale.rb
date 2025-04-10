class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https:www.planetscale.com"
  url "https:github.complanetscalecliarchiverefstagsv0.237.0.tar.gz"
  sha256 "c60c7375c64e0fc72f8b943df60086fb907950f0b08b772d84036aea41bf143e"
  license "Apache-2.0"
  head "https:github.complanetscalecli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6ea4d3d050bb4f196729cc7d222ec58ba6cbfc145b60e296fe9df757a102483"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3cee7f6a196cc3aaae32982e60d57a8848aaf619725d9fdfa04c958f2e71a66"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ced9cb00828eda69aec6438dc9a3a03deeb7d311b3d90bc010754183ee54678a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9afbb87ac5a76c3b1b0e0980f37f7a736c0260959b7be78f040dd7ae54032e48"
    sha256 cellar: :any_skip_relocation, ventura:       "dc9f8e0a8fd81b68d110618007d2c9cbb92788f348c3abe845acaed65edfbe12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8e5644115ede74db148e58a0a256eebed384600fa8e554fed582af327c25649"
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