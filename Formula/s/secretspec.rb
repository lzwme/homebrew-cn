class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://ghfast.top/https://github.com/cachix/secretspec/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "c8b7f3168205147cc0ed46e14dc482596c66f349979d541426d048392e51b766"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1be474b9b05bfc3039bb2c4488da0a7e7220ce25b5461e76ae359c981091faea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3f6d8a19ffaf839d722c973eb82f355aa43cdc7d655ffd7d3044aa1dc74da18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a4760208cc12be7f0ec9750d3a4c58616aad991004aa2bd36f4735c7ded43ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "f948c613304ca6954f7d50ce460633f4a79f6723d06f5812ed8666025e459794"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "813c0918a2677327fdbacceff8c29e7a11c2d01b39e1ec2b5fd2274184c8bc4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "879b81591c0d45a6d86940a7b263c51003833f9094b7952e31348104ff7d1f0e"
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