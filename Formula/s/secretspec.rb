class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://ghfast.top/https://github.com/cachix/secretspec/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "20190d9db8bb9ad088bd62466760cdc3dfa8e9a07f799c1d3566520829a19262"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2939f79488d40ddfd84518adb41bf4103d414153f219a53c73afee11a6e09794"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c47cc928ac701c6813d3cdbe7e455671ee2ccfc4e082877fb8ed45d4ded4f839"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f7dca7588a43310516779ead0c5c0792052de97da68e520bfe8c4bf0140b496"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a870f8d7bebaa3cf33bbb135db0c85957b1fe0330f78e02889c580c22033395"
    sha256 cellar: :any_skip_relocation, ventura:       "8acb1b258e95b8f2ec8460b750f051435c09f69b18d369b53701511fb3e9b0c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72df3eb7022807b2225adc3462c69be074f4b00d101490b704ec9d58e2ceb845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4197c6fed67652ae7c269f53de20dc730787b48514ef7d24de82a97c717ab85a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "secretspec")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/secretspec --version")
    system bin/"secretspec", "init"
    assert_path_exists testpath/"secretspec.toml"
  end
end