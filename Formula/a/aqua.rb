class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://ghfast.top/https://github.com/aquaproj/aqua/archive/refs/tags/v2.53.7.tar.gz"
  sha256 "b8155ac800bfd4bca6ef0f7dd54b048faf7b17fa25f8f3d9db06c63ff47719de"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f501fce34a1e73eb3dbeba7f085ac2f94af40a05a5a6dd5d06b0c7ba47611f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f501fce34a1e73eb3dbeba7f085ac2f94af40a05a5a6dd5d06b0c7ba47611f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f501fce34a1e73eb3dbeba7f085ac2f94af40a05a5a6dd5d06b0c7ba47611f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "065e3066f4e5e1f9fd5e651901e19c36d2dd4de2d7a0734c57558f10c7d00fe9"
    sha256 cellar: :any_skip_relocation, ventura:       "065e3066f4e5e1f9fd5e651901e19c36d2dd4de2d7a0734c57558f10c7d00fe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9970c9e6abc55403d8040dbc66dba28f361786c1e7c5469cf8a5b07f9751de5a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/aqua"

    generate_completions_from_executable(bin/"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aqua --version")

    system bin/"aqua", "init"
    assert_match "depName=aquaproj/aqua-registry", (testpath/"aqua.yaml").read
  end
end