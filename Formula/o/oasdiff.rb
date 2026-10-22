class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://ghfast.top/https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.34.1.tar.gz"
  sha256 "ebcf119ebc942694f4c3a9c0dfc9c6c6d401d803efb525a77aa973104e7b68d9"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d40c7d6d1455410b6ae52bc9dbe8813daf7f915c37209995169ed7c739bde708"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d40c7d6d1455410b6ae52bc9dbe8813daf7f915c37209995169ed7c739bde708"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d40c7d6d1455410b6ae52bc9dbe8813daf7f915c37209995169ed7c739bde708"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "365708e844217778b3dae2221543d53a88d92c01345f146341d4571fcbd5051e"
    sha256 cellar: :any,                 x86_64_linux:      "0eac5dd8f82abeff2eee4c03f0a2fb7e8d9fbcc3b665a487347e6695a9f29c55"
  end

  depends_on "go" => :build

  resource "homebrew-openapi-test1.yaml", :test do
    url "https://ghfast.top/https://raw.githubusercontent.com/oasdiff/oasdiff/8fdb99634d0f7f827810ee1ba7b23aa4ada8b124/data/openapi-test1.yaml"
    sha256 "f98cd3dc42c7d7a61c1056fa5a1bd3419b776758546cf932b03324c6c1878818"
  end

  resource "homebrew-openapi-test5.yaml", :test do
    url "https://ghfast.top/https://raw.githubusercontent.com/oasdiff/oasdiff/8fdb99634d0f7f827810ee1ba7b23aa4ada8b124/data/openapi-test5.yaml"
    sha256 "07e872b876df5afdc1933c2eca9ee18262aeab941dc5222c0ae58363d9eec567"
  end

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/oasdiff/oasdiff/build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"oasdiff", shell_parameter_format: :cobra)
  end

  test do
    testpath.install resource("homebrew-openapi-test1.yaml")
    testpath.install resource("homebrew-openapi-test5.yaml")

    expected = "[api-path-removed-without-deprecation]"
    assert_match expected, shell_output("#{bin}/oasdiff changelog openapi-test1.yaml openapi-test5.yaml")

    assert_match version.to_s, shell_output("#{bin}/oasdiff --version")
  end
end