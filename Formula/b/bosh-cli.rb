class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://ghfast.top/https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.9.19.tar.gz"
  sha256 "b6b4b0b4357843d085abed351c8eb7627218eeb391649a86203acd69071b4732"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27fb9a8e9d7be1596b0554f16d719f29ee7b3b74b268a83b32542211199a3569"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27fb9a8e9d7be1596b0554f16d719f29ee7b3b74b268a83b32542211199a3569"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27fb9a8e9d7be1596b0554f16d719f29ee7b3b74b268a83b32542211199a3569"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec00ab18fdd9a9dee6cef4b77fbf0873568c0cd01f857d79fbe433ebf7563a83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d1617d9a038ef9386202c2981c9b76a57cb744aeef2ba0489526fcca04434e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4064f70bd2c2487ad782cba660b05341a820254293f63dea8019602d1bfd86c0"
  end

  depends_on "go" => :build

  def install
    # https://github.com/cloudfoundry/bosh-cli/blob/master/ci/tasks/build.sh#L23-L24
    inreplace "cmd/version.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"bosh-cli", shell_parameter_format: :cobra)
  end

  test do
    system bin/"bosh-cli", "generate-job", "brew-test"
    assert_path_exists testpath/"jobs/brew-test"

    assert_match version.to_s, shell_output("#{bin}/bosh-cli --version")
  end
end