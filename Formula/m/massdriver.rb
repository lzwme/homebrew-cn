class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://ghproxy.com/https://github.com/massdriver-cloud/mass/archive/refs/tags/1.5.7.tar.gz"
  sha256 "622636c229052305fb908b679b0101acb1adc1921a4ea7f59ab4f096b90a65d2"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81f095218be5638ad928ee218a3b856c110f1764d04f92b151b9f54f3b26972d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc162d342114c2da4d1806e067e2746d4f7072cdc20fabece0f1413ad78c5ac1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e26c55954c28242eaa76cc63d979efb1f0f822c9b0ff424bebacf9a5a71c5a03"
    sha256 cellar: :any_skip_relocation, sonoma:         "00766f4b444234e7cc1413090188cbd90bb867bb7c9e55ed16b4160f89a8bae2"
    sha256 cellar: :any_skip_relocation, ventura:        "08ae16f96fbaa043ec88ed6533a0317058f2a825fad2de58af6acd51663179ea"
    sha256 cellar: :any_skip_relocation, monterey:       "6ae64c52df5195944853328360d2412e61a9d54732194a6feac3304d0fa09cb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d72cb524de82d4412539fc99e561a0828b3ce4ad3cd56d5a246e6c3acf549fe"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"mass")
    generate_completions_from_executable(bin/"mass", "completion")
  end

  test do
    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output

    output = shell_output("#{bin}/mass bundle lint 2>&1", 1)
    assert_match "OrgID: missing required value: MASSDRIVER_ORG_ID", output

    assert_match version.to_s, shell_output("#{bin}/mass version")
  end
end