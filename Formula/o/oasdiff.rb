class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://ghfast.top/https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.18.5.tar.gz"
  sha256 "d296ad60988e9ddc38485e33319287e6918c2936d1555ff45fa748a9585b95fa"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad4198a8aa927f080c80888fec7da7d669f1b9d679c2ac39911d014a34044644"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad4198a8aa927f080c80888fec7da7d669f1b9d679c2ac39911d014a34044644"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad4198a8aa927f080c80888fec7da7d669f1b9d679c2ac39911d014a34044644"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2e8695ca73845adfe8c2490c24a43c497406ec83bea35099aeb8e695e15fe73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5c8258ca1bdbf46e7efee8115aeb0ca392a905fed03698a5ed28d301ff10169"
    sha256 cellar: :any,                 x86_64_linux:  "b3ca2e95f3ee5b7ab5c28d76c13312d100e22044b8b6851ad841d8296a063acd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/oasdiff/oasdiff/build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"oasdiff", shell_parameter_format: :cobra)
  end

  test do
    resource "homebrew-openapi-test1.yaml" do
      url "https://ghfast.top/https://raw.githubusercontent.com/oasdiff/oasdiff/8fdb99634d0f7f827810ee1ba7b23aa4ada8b124/data/openapi-test1.yaml"
      sha256 "f98cd3dc42c7d7a61c1056fa5a1bd3419b776758546cf932b03324c6c1878818"
    end

    resource "homebrew-openapi-test5.yaml" do
      url "https://ghfast.top/https://raw.githubusercontent.com/oasdiff/oasdiff/8fdb99634d0f7f827810ee1ba7b23aa4ada8b124/data/openapi-test5.yaml"
      sha256 "07e872b876df5afdc1933c2eca9ee18262aeab941dc5222c0ae58363d9eec567"
    end

    testpath.install resource("homebrew-openapi-test1.yaml")
    testpath.install resource("homebrew-openapi-test5.yaml")

    expected = "11 changes: 3 error, 2 warning, 6 info"
    assert_match expected, shell_output("#{bin}/oasdiff changelog openapi-test1.yaml openapi-test5.yaml")

    assert_match version.to_s, shell_output("#{bin}/oasdiff --version")
  end
end