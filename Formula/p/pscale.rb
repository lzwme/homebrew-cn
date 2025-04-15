class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https:www.planetscale.com"
  url "https:github.complanetscalecliarchiverefstagsv0.240.0.tar.gz"
  sha256 "2b7f9cefaa362ce32c5c2b299ca1e1756f67936cace562df0dfb5df55f998196"
  license "Apache-2.0"
  head "https:github.complanetscalecli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11765f620876b383a078da4e92727d5cdce5b63c3b06ccd076bd8adf5ea1e3b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84f67d47feb910209f399fb7aa870262f56d8027ef69c1ba1cbda14ace370f82"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "01e1d43a88d922827dbda0d197583550ff786758ed269ac994841afe41c1fc78"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1fe1fa444e58cbfad0fced96aa89dce5a590a57ba7cc6ba868a2fa99b3a713b"
    sha256 cellar: :any_skip_relocation, ventura:       "f07551401ad6fccd47e9f13ebd07dccbc4b83283c24b95a20573ff6d56512ced"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87e4fde51553906ad5d990d6a2d4b4451d2efec752f1bb6c616a933664e431e5"
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