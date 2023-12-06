class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://ghproxy.com/https://github.com/segmentio/chamber/archive/refs/tags/v2.13.5.tar.gz"
  sha256 "f940d6fc70911bec5e192678866c25d5121356cb5f10d99b0046f9ec9d3e10cc"
  license "MIT"
  head "https://github.com/segmentio/chamber.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(?:-ci\d)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00a36236518fc3a8f2678afe4dc539ea307276d71834a2ac3bac14268d403060"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dea4798629bf252c0c7f9d71133765ce435ffe648767ace388f112592735e7e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4dc10f78764ee3105dfff6133821d67a1e8ef6f027c213541259c2f1e032b17"
    sha256 cellar: :any_skip_relocation, sonoma:         "fbb4c60c8104bd80832f75aaf4f803f57fa4dcebbd6638d27a337e5a948e4229"
    sha256 cellar: :any_skip_relocation, ventura:        "4af017eefd2241b8716e9e75632b1d03354ca260de27e271b4128b8cb6e31e4f"
    sha256 cellar: :any_skip_relocation, monterey:       "289fb4d6369ff6d278662f67a21467021d42625b7e5a71a40a0ef4237379aaaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f358506cbeb8e4752514d2bf020f7bb8faf28dfe044fd9cb7f5fc7098499a68"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
    generate_completions_from_executable(bin/"chamber", "completion")
  end

  test do
    ENV.delete "AWS_REGION"
    output = shell_output("#{bin}/chamber list service 2>&1", 1)
    assert_match "MissingRegion", output

    ENV["AWS_REGION"] = "us-west-2"
    output = shell_output("#{bin}/chamber list service 2>&1", 1)
    assert_match "NoCredentialProviders", output
  end
end