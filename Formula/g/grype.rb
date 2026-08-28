class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghfast.top/https://github.com/anchore/grype/archive/refs/tags/v0.118.0.tar.gz"
  sha256 "6963758836cd46fd019d4c5e2eb903ec26960c34814a35058ebea56971dc592c"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82a2f04e3392928c58a80273a336682708574a639e17b1f606a2210ac08a339b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c748a21c076ae4449b1b647b4e6050f7c781ceb8497bcc600c6c83bc7c2e45b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ba81e450133fa8936d7eba68c20509ebc49752775c9def62948b78e31db2ede"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82fa7b79d0abdd7ff7f37e85dae5a4b79846bb0783477187576b533d580f367d"
    sha256 cellar: :any,                 x86_64_linux:  "49e9a564ca91a18d4eca02ce902ff2a60eae4e78c12d4145078c5e9128530e46"
  end

  depends_on "go" => :build

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