class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://ghfast.top/https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "734596357d6a2743ccd3c1850f37090793793ec3dde88106e325f60d666c5f6f"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0c6b51877c94d2b624140fbfcbb97bb5a5354b43274ca5be7b2d15120ef705e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0c6b51877c94d2b624140fbfcbb97bb5a5354b43274ca5be7b2d15120ef705e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0c6b51877c94d2b624140fbfcbb97bb5a5354b43274ca5be7b2d15120ef705e"
    sha256 cellar: :any_skip_relocation, sonoma:        "91c84e2df5781744dba6cd17a5d4a2d249ba36b88fbe24e617fb5ec2136bcaa8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df5ef3c227fbb8c125d891c5ddf58452c0c7e0a19bba0341d2c7a688a5d245cc"
    sha256 cellar: :any,                 x86_64_linux:  "d03a21eda48393c00809a469938d269a143447ba8db3037f3f544ac3212234ba"
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

    expected = "3 error, 2 warning"
    assert_match expected, shell_output("#{bin}/oasdiff changelog openapi-test1.yaml openapi-test5.yaml")

    assert_match version.to_s, shell_output("#{bin}/oasdiff --version")
  end
end