class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghfast.top/https://github.com/anchore/grype/archive/refs/tags/v0.120.1.tar.gz"
  sha256 "4e90b488a42818aaf40dc7119f85c533302953778f8fac96e281bed5d06c8a68"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "195705efe03dff1cc5d1b7a0c22bdb48ec3206e63d0f59c0b8df124d566d37b8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3d160531947504b0413183b803b8fdb8fdf7d304f24c54d25da0e15a93d9f6e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3c9edeee83b8712dee86f6aeb3a14277f3f8ffaf38a34df892372566ad6d6389"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "85e937ef983898f3e0e8cbaede9ad7a4542199d174ff2d9b4a03578bf48367fd"
    sha256 cellar: :any,                 x86_64_linux:      "1b6627bfda4a79652158b0a9830ce12479b722b1adf2e04feac6471a0d67debf"
  end

  depends_on "go" => :build

  # `test do` block downloads the vulnerability database
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end