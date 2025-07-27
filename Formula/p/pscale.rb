class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.248.0.tar.gz"
  sha256 "550486570e84738de45a414d2cead63a236528d64bb11ba7a9b6cc98a3a5b7bd"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc575d840410711f9171311db3bbb38ca105de4aa36f814b170be9511391726c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b4621a25912a5a74377d8ddd61c3d91dc8c58ea5da6c48593e99e7cb3fb9c1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aec89d51e6fcd9d90e6dc3b5c8825fd78810ddda06c557dfae5d7b7a87ceecf4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebfe33f3e33608e094754c6ec0d458fca6eb14df6378d8dbb19dbab8efbcada5"
    sha256 cellar: :any_skip_relocation, ventura:       "4e7201348a92b1acf29d763678d8f7bb262f45a648e5b46b82cf2c1d0c949644"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e87d7c1efce7c32d2bf368398275143e32374d4223d912876f8790b178720dc1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end