class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://ghfast.top/https://github.com/aquaproj/aqua/archive/refs/tags/v2.53.3.tar.gz"
  sha256 "56f824f275e02b7061c5f826fa339f89f471f833d5820cc23067ebfaaa281f7d"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84e33a072953da721796d94ae3de06a9a618396298fb28fafd4e6b65a4b9f64e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84e33a072953da721796d94ae3de06a9a618396298fb28fafd4e6b65a4b9f64e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84e33a072953da721796d94ae3de06a9a618396298fb28fafd4e6b65a4b9f64e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdb0d3fe6083a63be49ce7e9c97678d0ac198367ec484db8e0889b3cac402792"
    sha256 cellar: :any_skip_relocation, ventura:       "bdb0d3fe6083a63be49ce7e9c97678d0ac198367ec484db8e0889b3cac402792"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6221b06fae09629c984a65c1a10b0d36a92ed851bb3b835a84ef59490ff7d357"
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