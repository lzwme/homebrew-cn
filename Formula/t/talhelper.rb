class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://ghfast.top/https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.1.4.tar.gz"
  sha256 "14059b17da5c256dbcda2117e1ffbbb9d8203b12036c06367e795cfb9973e2a7"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2adb8f6577b4d308d09b030e0f2ee04fe8b30ee7c6eb561ffd6ec189ea3ebef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2adb8f6577b4d308d09b030e0f2ee04fe8b30ee7c6eb561ffd6ec189ea3ebef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2adb8f6577b4d308d09b030e0f2ee04fe8b30ee7c6eb561ffd6ec189ea3ebef"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce2e8a34b84ebb4ffeb6c8ea90b6e42d37d8a4a7e21ef3d0378cfaf1c78f5918"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f1176345f9818b9d44847a55e1df4220f3d75382e6bfe3c4f5fb939e26c1805"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8a305f4664883cca5ee698ec91bee428c9d2813db1e570c835fdf683c10d938"
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