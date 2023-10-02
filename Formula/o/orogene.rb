class Orogene < Formula
  desc "`node_modules/` package manager and utility toolkit"
  homepage "https://orogene.dev"
  url "https://ghproxy.com/https://github.com/orogene/orogene/archive/refs/tags/v0.3.32.tar.gz"
  sha256 "59d8b55cebca88dbef6e2e9ea6b7014d996744d2e00592e3330318f506330bc9"
  license "Apache-2.0"
  head "https://github.com/orogene/orogene.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd41d3623c0a102aef8836d5d37a1cd809e1045cc2e6ee8a410c20b067648877"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05ef30a1da792598efc106ecdc5aef52c5c2cd617c9af03ed15d238b2048b38b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4141397f8698f16683a3488f99c30e8e4c095c7b33d9aaf35cbd3a6cbd443211"
    sha256 cellar: :any_skip_relocation, sonoma:         "711b153de2796ff65574671b0daaf4a4a1541b697d91f9e8bc7a8bba524c7a49"
    sha256 cellar: :any_skip_relocation, ventura:        "fbf8c03b6f480dac2a98a5fbf6b340eae8902b4c67eeb58e772c4422554ddba0"
    sha256 cellar: :any_skip_relocation, monterey:       "5721040306120c9b62bdf0364eb22efc615a6f442a1bdca9614a938f1fe4d3b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "802d1133a1c194a42ffecec0c5a2a42cadd290b4293d793062d52e43f3e023d8"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oro --version")
    system "#{bin}/oro", "ping"
  end
end