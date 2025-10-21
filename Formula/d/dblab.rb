class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://ghfast.top/https://github.com/danvergara/dblab/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "1d220f4722c69b6e91cfd5e2fd9aad8b9ef3a9b4edd1f047a17958e6585c79ec"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18680444256dd2be7de37e02992aa9ca6051fef8f664a0dcbc77eef19bfcb041"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b11a838ffc2355c35a188095f86147a7d6d943d233e7486970752a4f10aed67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89dabbe349e36f1a641b7c37fd146921027d0aa13ada89a29d1b65242e66a09a"
    sha256 cellar: :any_skip_relocation, sonoma:        "476f20ad296495d70cdd30663f65f8247b164d09de41583ee205cea85cf2b670"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4ea0c261157ad04a456aca0f8f4c355a2d22f6245b42b4499194492bb6e0275"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13ccb5d2cb78bca09f432716d2fa4243d02aa7a02b3d038148a88578f7b8a62d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end