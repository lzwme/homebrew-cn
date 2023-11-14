class Changie < Formula
  desc "Automated changelog tool for preparing releases"
  homepage "https://changie.dev/"
  url "https://ghproxy.com/https://github.com/miniscruff/changie/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "ac32576c08cd0cdb89dd939c4a23e53e02225df576a7483186dc5bd43fa5ac2c"
  license "MIT"
  head "https://github.com/miniscruff/changie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d393870a8330e58c6e45cfca3b5792483eed14607472fd748e7910610980cfda"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a1886b4559913de3ce51fa6cccd7fc0a2328357862d957ee1f1d77d186957e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55593aae3d0742f47f4d8bbe70cbb7dbd5b2d7d354fe57ac780c5641f1a2a5ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb609b9251caae5491fb5803a340a7971880219680d11fd331731ef0032d57b7"
    sha256 cellar: :any_skip_relocation, ventura:        "4ac595aac3fa618f281864cb93f0d051b76642d74cbe96f89aa4bead40bcac75"
    sha256 cellar: :any_skip_relocation, monterey:       "6a2c6c9e1dd8b5af9efb4714e53bf8611c97686709dc464bdf8e7027dfd95f62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f017de116d704fe4c248bc2ccb1680fd97fdab4ba24873c6b5e5dec70493fbe"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"changie", "completion")
  end

  test do
    system bin/"changie", "init"
    assert_match "All notable changes to this project", (testpath/"CHANGELOG.md").read

    assert_match version.to_s, shell_output("#{bin}/changie --version")
  end
end