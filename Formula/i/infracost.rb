class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https:www.infracost.iodocs"
  url "https:github.cominfracostinfracostarchiverefstagsv0.10.32.tar.gz"
  sha256 "03ed61f77cbdd7b192681259c71427e6b111400762cc14cd624a15ae4e82188c"
  license "Apache-2.0"
  head "https:github.cominfracostinfracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "244f43660cfb85c18d18fd6c0f7c6b2ebf4bd586d4ee0bc5e119990170f1f21a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "244f43660cfb85c18d18fd6c0f7c6b2ebf4bd586d4ee0bc5e119990170f1f21a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "244f43660cfb85c18d18fd6c0f7c6b2ebf4bd586d4ee0bc5e119990170f1f21a"
    sha256 cellar: :any_skip_relocation, sonoma:         "88087ebe3df87b7ff98f27b01622cb6b74906c81b676f0325e49c3da0da0babc"
    sha256 cellar: :any_skip_relocation, ventura:        "88087ebe3df87b7ff98f27b01622cb6b74906c81b676f0325e49c3da0da0babc"
    sha256 cellar: :any_skip_relocation, monterey:       "88087ebe3df87b7ff98f27b01622cb6b74906c81b676f0325e49c3da0da0babc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ef353d8fe9283a82d0adcb3d14ce25fd136ea4e3f1dc33e10fed4917e864ebf"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.cominfracostinfracostinternalversion.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdinfracost"

    generate_completions_from_executable(bin"infracost", "completion", "--shell")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}infracost --version 2>&1")

    output = shell_output("#{bin}infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end