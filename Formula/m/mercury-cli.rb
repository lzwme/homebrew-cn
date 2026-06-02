class MercuryCli < Formula
  desc "CLI interface for Mercury banking"
  homepage "https://github.com/MercuryTechnologies/mercury-cli"
  url "https://ghfast.top/https://github.com/MercuryTechnologies/mercury-cli/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "df042ebd7f4acab549be14a781b64b9f16bf78ee60266a6b2c655ebbc8119b08"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c10e7ec2490824a2c73a8261de2feeddc8be1448466859c5f8740aeb3121b0bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c10e7ec2490824a2c73a8261de2feeddc8be1448466859c5f8740aeb3121b0bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c10e7ec2490824a2c73a8261de2feeddc8be1448466859c5f8740aeb3121b0bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "376fa1d6cd002e8c706a53b64136f8dcdf0ff4e5b8ad958d4fa244c4648238dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c80670f450f497c6117b4ce7d52b32fb85a0b3b69bc6569a97331b30bd76c99d"
    sha256 cellar: :any,                 x86_64_linux:  "0eea02c83a516309b3ee0205c868bdacba50ca974f68bb108c8bf422275e0624"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"mercury"), "./cmd/mercury"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mercury --version")
    assert_match "Authentication Status", shell_output("#{bin}/mercury status 2>&1")
    assert_match "Your dedication to modern banking has not gone unnoticed", pipe_output("#{bin}/mercury hat 2>&1")
  end
end