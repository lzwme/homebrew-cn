class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https:www.oasdiff.com"
  url "https:github.comTufinoasdiffarchiverefstagsv1.10.25.tar.gz"
  sha256 "878018d77b349d76811da8ff677ebc1e195581a1e148ff38d81c42d7c4d56b93"
  license "Apache-2.0"
  head "https:github.comTufinoasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8eb649f4a71464ac369ce586767bbd7819046c27a42824083eae49ce28436261"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8eb649f4a71464ac369ce586767bbd7819046c27a42824083eae49ce28436261"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8eb649f4a71464ac369ce586767bbd7819046c27a42824083eae49ce28436261"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3415274bc963f1ee079394b5dc8f5a4d57313456254dbf6c992d4a85a297b67"
    sha256 cellar: :any_skip_relocation, ventura:       "b3415274bc963f1ee079394b5dc8f5a4d57313456254dbf6c992d4a85a297b67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f68bbd076053fcdfde02ac41cec7ec895511b451d187f76d998466bf92afe2c"
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