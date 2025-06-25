class VulsioGost < Formula
  desc "Local CVE tracker & notification system"
  homepage "https:github.comvulsiogost"
  url "https:github.comvulsiogostarchiverefstagsv0.6.0.tar.gz"
  sha256 "95b92827e242d02ed6b44b2d268bc3f5a145243d1e2648b4f1804cb92c7d6862"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48fcedb2f0050ce321a30cfaca9f46b95a92366efe1eb8dfd3537db9fe6e5c77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48fcedb2f0050ce321a30cfaca9f46b95a92366efe1eb8dfd3537db9fe6e5c77"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48fcedb2f0050ce321a30cfaca9f46b95a92366efe1eb8dfd3537db9fe6e5c77"
    sha256 cellar: :any_skip_relocation, sonoma:        "74f6d4d83ccee13c11bfb4175d681aac086a6b18e780a9c3407abf5dd4227779"
    sha256 cellar: :any_skip_relocation, ventura:       "74f6d4d83ccee13c11bfb4175d681aac086a6b18e780a9c3407abf5dd4227779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b6405bb9c5b14e65e07aa79dfb7f81074ab717570f50c95a1f5ad095fbd5566"
  end

  depends_on "go" => :build

  conflicts_with "gost", because: "both install `gost` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comvulsiogostconfig.Version=#{version}
      -X github.comvulsiogostconfig.Revision=#{tap.user}
    ]
    system "go", "build", *std_go_args(output: bin"gost", ldflags:)

    generate_completions_from_executable(bin"gost", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gost version")

    output = shell_output("#{bin}gost fetch debian 2>&1")
    assert_match "Fetched all CVEs from Debian", output
  end
end