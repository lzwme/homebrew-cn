class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://ghfast.top/https://github.com/okteto/okteto/archive/refs/tags/3.13.0.tar.gz"
  sha256 "fd845af52960f238e1c5473890fb88d21ebab70427bdcfed6b488da40b9b3849"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "724fb12ebbc2f671b80f643860b7bd9d1dc1c7c921a1449d46f0c757f67e3962"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a944b476879f53ce0b9f180dcff27e5c11f9fc46be6563fd9d7b6619c928746"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e53a6cd96cbf9bd82af0f67d4c763002b8366349c47b73e2026d9028a990778"
    sha256 cellar: :any_skip_relocation, sonoma:        "8edb984951781409edcc7a2d197344f22335f42be14515c91b59c594e8245650"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fc32a54c821f22711c7c293887c9587c940c37ea74c9137fe105c3bdcaa032b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "099e542c212e1bac0147bf2922a44af35ffe11d7b277738c53fd41b3d8a5ada2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Your context is not set", shell_output("#{bin}/okteto context list 2>&1", 1)
  end
end