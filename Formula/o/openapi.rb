class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "7ec2201c6d2c70a1cb2cd448c19083e2d3a5aaa67d407f8fbeddc6fb18501ff5"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ef9a95708e5a168bbc7699519c691718f97961e1d98d93a5058c31be8fd10f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ef9a95708e5a168bbc7699519c691718f97961e1d98d93a5058c31be8fd10f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ef9a95708e5a168bbc7699519c691718f97961e1d98d93a5058c31be8fd10f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6cacdd9765fbedd363f88963112336b0965cfd4801013b5ba59d93a5c7386b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5dedffe4b0ec702e60902d648e454658be203df70033eccca65d4442ceb74ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38ff38b27805c8ee77c14499131ffbf3638324092a502ff3796b6d170a56690f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openapi"

    generate_completions_from_executable(bin/"openapi", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openapi --version")

    system bin/"openapi", "spec", "bootstrap", "test-api.yaml"
    assert_path_exists testpath/"test-api.yaml"

    system bin/"openapi", "spec", "validate", "test-api.yaml"
  end
end