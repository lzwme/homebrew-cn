class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghfast.top/https://github.com/anchore/grype/archive/refs/tags/v0.103.0.tar.gz"
  sha256 "27535c95a184f5546cacba8c550d60dc3099f3c286c7c08f1b58d81319dbf0a2"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9f3754b5468c42de21971f0d08b2fa7ca2186335784ad18f8332714142f61d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f91e2a97c1a7c1c40236a00564d5b657ec5117e6c3f60e7c4315ca891870c9ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5949be20b0e06e23aca1bbff183f251c4dffac25cfbea8a46e2c8c2ff4ec24f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6a04d453ca1a8ac165b18a627fdf13b5f37735c0112e3fcadbfc627f35b3444"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1aec783e0fdab9405cb2f12477c592ef9ab554294ee0c470cbb5c220274e0f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65b76287dbdddfd1db75fa93d64ff147bbbd73a3d43e8cfdb81733da6992c009"
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