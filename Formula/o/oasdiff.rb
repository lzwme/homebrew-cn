class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https:www.oasdiff.com"
  url "https:github.comTufinoasdiffarchiverefstagsv1.10.29.tar.gz"
  sha256 "aeb12389da462ef83e7348ac8b9e90d07af526ce3a86a20b92b401f2c109bb80"
  license "Apache-2.0"
  head "https:github.comTufinoasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9554db562a9d9317df9c1767348a78f2926c5c7ce0cab43f303c8c64e3921849"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9554db562a9d9317df9c1767348a78f2926c5c7ce0cab43f303c8c64e3921849"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9554db562a9d9317df9c1767348a78f2926c5c7ce0cab43f303c8c64e3921849"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d79e72048874757a763b80c3ab04fb7fdf905bb5027165b9e33c10cdf6c26ec"
    sha256 cellar: :any_skip_relocation, ventura:       "4d79e72048874757a763b80c3ab04fb7fdf905bb5027165b9e33c10cdf6c26ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94b5aa2e0bc5435823589f43e9bac00cea3b145656d0fd2d9e3e61de4966206a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comtufinoasdiffbuild.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"oasdiff", "completion")
  end

  test do
    resource "homebrew-openapi-test1.yaml" do
      url "https:raw.githubusercontent.comTufinoasdiff8fdb99634d0f7f827810ee1ba7b23aa4ada8b124dataopenapi-test1.yaml"
      sha256 "f98cd3dc42c7d7a61c1056fa5a1bd3419b776758546cf932b03324c6c1878818"
    end

    resource "homebrew-openapi-test5.yaml" do
      url "https:raw.githubusercontent.comTufinoasdiff8fdb99634d0f7f827810ee1ba7b23aa4ada8b124dataopenapi-test5.yaml"
      sha256 "07e872b876df5afdc1933c2eca9ee18262aeab941dc5222c0ae58363d9eec567"
    end

    testpath.install resource("homebrew-openapi-test1.yaml")
    testpath.install resource("homebrew-openapi-test5.yaml")

    expected = "11 changes: 3 error, 2 warning, 6 info"
    assert_match expected, shell_output("#{bin}oasdiff changelog openapi-test1.yaml openapi-test5.yaml")

    assert_match version.to_s, shell_output("#{bin}oasdiff --version")
  end
end