class Descope < Formula
  desc "Command-line utility for performing common tasks on Descope projects"
  homepage "https:www.descope.com"
  url "https:github.comdescopedescopecliarchiverefstagsv0.8.8.tar.gz"
  sha256 "f702ec192820018a9466cf2e21c3fc0a77740c6d942e3e2f7a45ab2c1768a03c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "798ba9359419fba430cf9d1bfbbbe36cc4058e728262e2783ceac5c50357cb67"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "798ba9359419fba430cf9d1bfbbbe36cc4058e728262e2783ceac5c50357cb67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "798ba9359419fba430cf9d1bfbbbe36cc4058e728262e2783ceac5c50357cb67"
    sha256 cellar: :any_skip_relocation, sonoma:         "c3a783b831fab284e76c362612390b298078ae34da917b4dca92db541a7ce7ed"
    sha256 cellar: :any_skip_relocation, ventura:        "c3a783b831fab284e76c362612390b298078ae34da917b4dca92db541a7ce7ed"
    sha256 cellar: :any_skip_relocation, monterey:       "c3a783b831fab284e76c362612390b298078ae34da917b4dca92db541a7ce7ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ace06aa3a496acedb5193a82d359ecce3257f3e9bfde1ad52c1feffae75ee1e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin"descope", "completion")
  end

  test do
    assert_match "working with audit logs", shell_output("#{bin}descope audit")
    assert_match "managing projects", shell_output("#{bin}descope project")
    assert_match version.to_s, shell_output("#{bin}descope --version")
  end
end