class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghfast.top/https://github.com/anchore/grype/archive/refs/tags/v0.99.0.tar.gz"
  sha256 "47309ce30713777463022c9193c754510a3417e0af1f4c4f6a1f72708eface2a"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cf919293f6723f9573978186c4e2c3ed876f56b0eb6af0e94f86274b709ccc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00c0bcd6a6beda8dfa6c200349e08cd9f7eb194725481f86fc5238feb7edcc5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19fdddf855be45d5803bb43bb4a435c0da5ce6181a438b5eb765b123f7f91c0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3b15bcf12138723e3233d278577f7c50e88dd34d737a1a150f0b51b17b96832"
    sha256 cellar: :any_skip_relocation, ventura:       "2719d01b8f9a8fdcb54b82770f6c2630af58aab6863b6cf73216c36e38ab9c70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9db3b28513c8e60681cecb8063762020c8bf42d889b430386f8573588a9f3dab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79184b8d0313fe81bd093ad3364226fc92fbbe7f941f9cbf4b403bd6c42a8973"
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