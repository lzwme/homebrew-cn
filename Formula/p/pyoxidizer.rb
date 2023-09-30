class Pyoxidizer < Formula
  desc "Modern Python application packaging and distribution tool"
  homepage "https://github.com/indygreg/PyOxidizer"
  url "https://ghproxy.com/https://github.com/indygreg/PyOxidizer/archive/refs/tags/pyoxidizer/0.24.0.tar.gz"
  sha256 "d52a2727a18a3414d7ec920b8523ef4d19cb2e6db3f1276b65a83e5dd4ae8d24"
  license "MPL-2.0"
  head "https://github.com/indygreg/PyOxidizer.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^pyoxidizer/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6124e2f8cd40cd7462fa28f70b719edce33751cda845bc1a56284b94290275a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa37a4ac504621090ea1f67abee2694e8c6798f5f8b35dba0f67411d70c9e133"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32a2e334bd1345638385aa4d56b635b8faecb5095607ed4f177660965979478d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6286b57cb42b275d4f6325e17842cd49bc6bedb9804616349a95250e96eb8294"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ef7aac85b9e30d86343ca1e51b84991ad4db83aff58bf885aef6b43218005ac"
    sha256 cellar: :any_skip_relocation, ventura:        "46aa367ab70a1488edd31411f85942a7179c090feecd1cdfa46735668d80b457"
    sha256 cellar: :any_skip_relocation, monterey:       "ea59d68a7bcdf1237d3eb72348901ea846546598194a44758e4db2521cc38880"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b9f21cdbd215dbaf5c0a41e70674244b4e192e6a64e6a4e1a3e03c933e4670a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0648492b46bc163e396b0e6e2ca99350a937476050c158dd5d8a32b9b0fc102d"
  end

  depends_on "rust" => [:build, :test]
  # Currently needs macOS 11 SDK due to checking for DeploymentTargetSettingName
  # Remove when issue is fixed: https://github.com/indygreg/PyOxidizer/issues/431
  on_catalina :or_older do
    depends_on xcode: "12.2"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "pyoxidizer")
  end

  test do
    system bin/"pyoxidizer", "init-rust-project", "--system-rust", "hello_world"
    assert_predicate testpath/"hello_world/Cargo.toml", :exist?

    cd "hello_world" do
      if Hardware::CPU.arm? && OS.mac? && MacOS.version < :ventura
        # Use Python 3.8 to work around:
        # https://github.com/Homebrew/homebrew-core/pull/136910#issuecomment-1704568838
        inreplace "pyoxidizer.bzl",
                  "dist = default_python_distribution()",
                  "dist = default_python_distribution(python_version='3.8')"
      end
      system bin/"pyoxidizer", "build", "--system-rust"
    end

    assert_match version.to_s, shell_output("#{bin}/pyoxidizer --version")
  end
end