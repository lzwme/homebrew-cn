class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https:www.cloudquery.io"
  url "https:github.comcloudquerycloudqueryarchiverefstagscli-v6.14.1.tar.gz"
  sha256 "3fa408321755d087431a2278cc69416b9ae7ffd12ae21743d96b051c326b4bdd"
  license "MPL-2.0"
  head "https:github.comcloudquerycloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(^cli-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "885313ea50171a8a1fafe0be83b2e830b445b40747a202e7126442615ec6faf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "885313ea50171a8a1fafe0be83b2e830b445b40747a202e7126442615ec6faf5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "885313ea50171a8a1fafe0be83b2e830b445b40747a202e7126442615ec6faf5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b5a4cfb1e81ba04001911eba0d711be2f36ce0a9d89211391eebb8842ff289a"
    sha256 cellar: :any_skip_relocation, ventura:       "6b5a4cfb1e81ba04001911eba0d711be2f36ce0a9d89211391eebb8842ff289a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c57defc9287973a7ccc325c6537d9352ab54ede37f11974c3e8c2e728b83f6ec"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = "-s -w -X github.comcloudquerycloudquerycliv6cmd.Version=#{version}"
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    system bin"cloudquery", "init", "--source", "aws", "--destination", "bigquery"

    assert_path_exists testpath"cloudquery.log"
    assert_match <<~YAML, (testpath"aws_to_bigquery.yaml").read
      kind: source
      spec:
        # Source spec section
        name: aws
        path: cloudqueryaws
    YAML

    assert_match version.to_s, shell_output("#{bin}cloudquery --version")
  end
end