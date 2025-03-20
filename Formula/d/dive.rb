class Dive < Formula
  desc "Tool for exploring each layer in a docker image"
  homepage "https:github.comwagoodmandive"
  url "https:github.comwagoodmandivearchiverefstagsv0.12.0.tar.gz"
  sha256 "2b69b8d28220c66e2575a782a370a0c05077936ae3ce69180525412fcca09230"
  license "MIT"
  revision 1
  head "https:github.comwagoodmandive.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44b9241dc0d0cedd1eec7b294b1fcfea2f01afc319709b88ad5ba61fb7c69df4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44b9241dc0d0cedd1eec7b294b1fcfea2f01afc319709b88ad5ba61fb7c69df4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44b9241dc0d0cedd1eec7b294b1fcfea2f01afc319709b88ad5ba61fb7c69df4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e2e5f58c3bd4a14dd5439a912ad552fe5396fe9d2e318995fa1a0e50c7ea275"
    sha256 cellar: :any_skip_relocation, ventura:       "8e2e5f58c3bd4a14dd5439a912ad552fe5396fe9d2e318995fa1a0e50c7ea275"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e45819927ba03dad0ff53a6549135d7bfc7b84c6e49ad6cac64829fa13e124ac"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    (testpath"Dockerfile").write <<~DOCKERFILE
      FROM alpine
      ENV test=homebrew-core
      RUN echo "hello"
    DOCKERFILE

    assert_match "dive #{version}", shell_output("#{bin}dive version")
    assert_match "Building image", shell_output("CI=true #{bin}dive build .", 1)
  end
end