class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://ghfast.top/https://github.com/aquaproj/aqua/archive/refs/tags/v2.55.3.tar.gz"
  sha256 "7276fd297695f8770c7c4564c92999d4c6a3e92ab4f7b4f03eb543083eecfdb4"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11f5a81facc7c4b72c257b863bf781228ed5f2e4d20f3afc6b4a3f132c2d69d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11f5a81facc7c4b72c257b863bf781228ed5f2e4d20f3afc6b4a3f132c2d69d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11f5a81facc7c4b72c257b863bf781228ed5f2e4d20f3afc6b4a3f132c2d69d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "c11fe47b69a759bbf8479417d86af73e2adbd3dc20fc7c1754945abe54fd8c6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65345bafb9d31c5004b23aa4ab166da79e4c32b6db98ba5106d6bdf5fe7fc878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d45cd03e639071e01d013ff8ea46f7384774a705556b63df9fc3762315a63bc3"
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