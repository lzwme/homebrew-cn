class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://ghfast.top/https://github.com/danvergara/dblab/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "3119b20eb8b2a3bfc5ecbcbe20cbc84fa3990d18a011ea5a76ec9b2233fa3147"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a53aabd6a9b4f2406023dd3da1da568dbe5c92620262a8a0627e64e6c85b901"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a53aabd6a9b4f2406023dd3da1da568dbe5c92620262a8a0627e64e6c85b901"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a53aabd6a9b4f2406023dd3da1da568dbe5c92620262a8a0627e64e6c85b901"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "965af29539887b49a67df2d1b91b3d2cdcdf3f91694451e0ebe3c2a625294cae"
    sha256 cellar: :any,                 x86_64_linux:  "da557124f0d31ee8d29a19551ce0bc64ddeaae0bdb7186b9cca1e23a5bfe5e79"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end