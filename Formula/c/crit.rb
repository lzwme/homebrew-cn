class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://ghfast.top/https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.18.4.tar.gz"
  sha256 "7e49e35f8646b693be29f7998d3770c03e4cdf97746a36ca81ed718ab0ad65af"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fae64027b37942086b8f23e2d71d8f69c65604b48ee17a58647d967377a81f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fae64027b37942086b8f23e2d71d8f69c65604b48ee17a58647d967377a81f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fae64027b37942086b8f23e2d71d8f69c65604b48ee17a58647d967377a81f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a623deae535bb15e224e72bf15faf8ab1ddfbbfd8a4b402414b2cbfdda78577"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89014a382f9f1a45b41cc7c94f8e81d81f405e0171bc6ea6b2785fe1f0021e22"
    sha256 cellar: :any,                 x86_64_linux:  "929a7da0e00800dd34955b22327f96cbe66059e90c64c82e8e80095f3b3923d7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=brew
      -X main.date=#{time.iso8601[0, 10]}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/crit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crit --version")

    (testpath/"hello.md").write("# Hello\n")
    system bin/"crit", "comment", "-o", testpath, "hello.md:1", "looks good"

    assert_path_exists testpath/"reviews"
  end
end