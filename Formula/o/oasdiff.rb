class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https:www.oasdiff.com"
  url "https:github.comoasdiffoasdiffarchiverefstagsv1.11.2.tar.gz"
  sha256 "d46b26e4e1ad51c0386678403bbfbfa0141f6cb0553db510b82a1a61abf700fc"
  license "Apache-2.0"
  head "https:github.comoasdiffoasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d27253054742196f10d6fcaf47bb0e4d7029cd073ee807498c18a5fa32882e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d27253054742196f10d6fcaf47bb0e4d7029cd073ee807498c18a5fa32882e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d27253054742196f10d6fcaf47bb0e4d7029cd073ee807498c18a5fa32882e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ede7b8caf47745f439a4091fae1d21979fd7ab5e2ab6c264c8c4aeb64d329fd9"
    sha256 cellar: :any_skip_relocation, ventura:       "ede7b8caf47745f439a4091fae1d21979fd7ab5e2ab6c264c8c4aeb64d329fd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "093323046e61efdc42f69c25266cb62caefac6c04d7c8feb744e503a9a61237a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comoasdiffoasdiffbuild.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"oasdiff", "completion")
  end

  test do
    resource "homebrew-openapi-test1.yaml" do
      url "https:raw.githubusercontent.comoasdiffoasdiff8fdb99634d0f7f827810ee1ba7b23aa4ada8b124dataopenapi-test1.yaml"
      sha256 "f98cd3dc42c7d7a61c1056fa5a1bd3419b776758546cf932b03324c6c1878818"
    end

    resource "homebrew-openapi-test5.yaml" do
      url "https:raw.githubusercontent.comoasdiffoasdiff8fdb99634d0f7f827810ee1ba7b23aa4ada8b124dataopenapi-test5.yaml"
      sha256 "07e872b876df5afdc1933c2eca9ee18262aeab941dc5222c0ae58363d9eec567"
    end

    testpath.install resource("homebrew-openapi-test1.yaml")
    testpath.install resource("homebrew-openapi-test5.yaml")

    expected = "11 changes: 3 error, 2 warning, 6 info"
    assert_match expected, shell_output("#{bin}oasdiff changelog openapi-test1.yaml openapi-test5.yaml")

    assert_match version.to_s, shell_output("#{bin}oasdiff --version")
  end
end