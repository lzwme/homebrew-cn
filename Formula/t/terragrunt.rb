class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.51.9.tar.gz"
  sha256 "0bca8c4cc8cd59098dde0cf90ae04fc5b9b755089bc33e97642140b90ec118b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef58168bc7a320713dfd2f57516bc57ae17a204a007ef26d346f6cf031d70df4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "076b7acb513327c2f3e97c5909f42c469199b3136c6e090e2f87af8537d30eea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a2df9e4043aa792eb15026a39ecdfb9ddd9514d1899b0b2ef8cb51b6a5a2b9a"
    sha256 cellar: :any_skip_relocation, sonoma:         "07b285312a6a2578169246a92467d37c1d922ef4a603a8541b9babbce853a149"
    sha256 cellar: :any_skip_relocation, ventura:        "b46c773ba64b0d2fbc4a3e59eed84efd6fd15bd947e263f886dee2445daf9758"
    sha256 cellar: :any_skip_relocation, monterey:       "d50fdac1dc571b2f045eb70412e725cabeb83c8e6f1ab9139c89bfae1703a041"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "087e2fabeeca19519d6092891ee703c87ce7a18bd9a32ddcc59a8c676526b4e6"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end