class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://ghfast.top/https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.0.38.tar.gz"
  sha256 "ee3edcda197eac41b2cf374490f34ab328ac8cbfb211031215f71d6d076a2afe"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "adfe6f9c309524c1abfe005f0f84c3f413461003f9b1f7856c649985e5aa4894"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adfe6f9c309524c1abfe005f0f84c3f413461003f9b1f7856c649985e5aa4894"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adfe6f9c309524c1abfe005f0f84c3f413461003f9b1f7856c649985e5aa4894"
    sha256 cellar: :any_skip_relocation, sonoma:        "1692042565670644d48777fa294bcde7d95984fd3ee1e31e770546ef1ac006d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c4d4ee58d059e9424acaab8bd569ceb6190e52f102357f3ca618ac876294352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bf03eb0d82f913c382e6fb3e3ed6ce05208d56905ca37640999a8c6522b84e7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/v#{version.major}/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}/example/*"], testpath

    output = shell_output("#{bin}/talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}/talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}/talhelper --version")
  end
end