class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https:www.planetscale.com"
  url "https:github.complanetscalecliarchiverefstagsv0.235.0.tar.gz"
  sha256 "13214d86870b7e3f6869e9099920f6e01296d6f590360529dceae848a8777822"
  license "Apache-2.0"
  head "https:github.complanetscalecli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "deaae947411cf67da532da7550ffb75ec5cede0486ccf02a250dcd625ea688a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be68a4ecf4ae52531bcafeb4ce2023cef91d299d2a145c022ebfea059a77a3b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8017a36922943254dd5aeb82562996536504f143a138967f3eebb20a3e570f13"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c75521cda16f3e6787c7a61ac110a2585850ab5a8f4b2fce3631badd22e2d55"
    sha256 cellar: :any_skip_relocation, ventura:       "d4bfcf601e693d2e17315ac6a31bd4e24e163e788bf36c755242fd6e8493356b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1a31f1dc9f5df61e12ed0c964184ed9d42bed97b89c9df47f32740e5822fe64"
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