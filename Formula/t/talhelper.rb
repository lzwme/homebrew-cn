class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://ghfast.top/https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.1.11.tar.gz"
  sha256 "68d8298ef165fca454e2953dc61d403946060bb0b2154c0a4e1cbeb048c96eb6"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc5f9e94995bf687b3d526198adf2fa391ea5a26c68a9a9b0b386708a6384f0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc5f9e94995bf687b3d526198adf2fa391ea5a26c68a9a9b0b386708a6384f0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc5f9e94995bf687b3d526198adf2fa391ea5a26c68a9a9b0b386708a6384f0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b6f26fc2563d734cd6dd3a8937d39d37979bda48590c7b277bf62807b73b2b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "277941b47c668c29b253eb93845c5b57ebbe98e21b7cf39b074f1f94c6141240"
    sha256 cellar: :any,                 x86_64_linux:  "5a7ef848080a16e8084be9660a55a399f66f7bf09d43a00a1ace4eaec0cfcabc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/v#{version.major}/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"talhelper", shell_parameter_format: :cobra)
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