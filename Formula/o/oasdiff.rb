class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://ghfast.top/https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "267dbb24cebafc86ea3a85c69be9db043a707256a74899343a75f2b1eb47f334"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e15869012a5fb97ab5b506ba1cd390dcfbe5bea52a69884adb4e624e3a31234a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e15869012a5fb97ab5b506ba1cd390dcfbe5bea52a69884adb4e624e3a31234a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e15869012a5fb97ab5b506ba1cd390dcfbe5bea52a69884adb4e624e3a31234a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f41e952bea0ac33ea5b0fd85215d2258d796216dab0983683187eb0f078111e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "068432fa79c3ecc7d24192abc03a2f3e863150def7dd616c7ec60bda8bd4934f"
    sha256 cellar: :any,                 x86_64_linux:  "10867b22c2052ce6b204bb9eae820bed37b83fc7987a245757a84b0c77129ce5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/oasdiff/oasdiff/build.Version=#{version}"
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