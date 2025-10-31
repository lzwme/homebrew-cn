class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://ghfast.top/https://github.com/turbot/steampipe/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "f01a88474771b4ecfe41a39d705f7901ea86057b287f84dfb9db1cb808816196"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ca46de2b70fd584fdf61cce12492139037695c53b13c4efadc164ff349534ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7db6948190be01dad9bfc8f28c48e056b616c321ace3a3d09ec68523ed1012a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce1190031a88db7796805dcb0575f5984ec47767ea0887d76c0a65c139b74a27"
    sha256 cellar: :any_skip_relocation, sonoma:        "359117d05e53dfddfcffe3c1b767d6f4994185f45ff80f752083f6e2820a0282"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a1505ed1b25210ec2fb1227241b53755346445342a4e54b48520db72fe1a9c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a5f20f89c8b2e8cf9fc9be2bddb109cfdc82e84c7788eb463fa351e8adba032"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    ENV["STEAMPIPE_INSTALL_DIR"] = testpath

    output = shell_output("#{bin}/steampipe service status")
    assert_match "Steampipe service is not installed", output

    assert_match "Steampipe v#{version}", shell_output("#{bin}/steampipe --version")
  end
end