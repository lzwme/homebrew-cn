class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghfast.top/https://github.com/anchore/grype/archive/refs/tags/v0.107.1.tar.gz"
  sha256 "9cc155d5b168f6ba6807b0e95ef191687c4d4e43d7e43f04c86eadf8649ec491"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9edd5bc23e37a8e4484e2515511784934e4c1badeb06507f2a5b5b45e3d7530"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "903a6eec98c02968f76082affe6ef72cc7a3cbb699f62fd6e182339e84861933"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62b27b84fb18171104f695c25569a2a0f84e3dc4d312ecad61b21907ca91242f"
    sha256 cellar: :any_skip_relocation, sonoma:        "069ce5eeff83bef9f96f00ad8b07018af75dac5a2fbdec0f3c29cb7a64cf54f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35d577c99f340720d25ac95f4075b1a6b6fbe099280cada5b69a22fa7abfb3c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c9bf49e69f0600e0924501ddfb526c3f291361e2ec9406f08957136b8fd72a9"
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