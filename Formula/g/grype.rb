class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghfast.top/https://github.com/anchore/grype/archive/refs/tags/v0.104.3.tar.gz"
  sha256 "15443105d7c41e1733c847754510e71c6eb28723dc9f1ffdc62218681b879bc6"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eaac0410db2a1ba1a1911ba002b82983233972d8c2fc23a7e33379f13f3ee4e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6421492126637765acab5fd494c6632c8c2e1ce6a6ac1b0c198be78cbffb897"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "375bd6b14067647e8e838826a4688d09f1d5e0625d082b75b5bebb2804256612"
    sha256 cellar: :any_skip_relocation, sonoma:        "99bfdfcfc05523a185f312bf52048d3b0b4e0f275132030f6d54f8e8494cdd34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9dfb6b03b4175f4a5c0186ed5498039e1ad955f9f154c289e3c972f61cbca0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5b5737dc5ba79e56da9ca28cfaafedde15adbaad251f9d36f806d33d6222278"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end