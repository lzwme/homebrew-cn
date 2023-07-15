class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://ghproxy.com/https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "276c62e909972695113288b38829e66e1eb8d3bfdbb37a497f582e59647a6a3e"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38449d2353412e41950d0845233e4445dcb4c8ce8f91d60aa6b3511b61afa553"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6587a0690062cabe274a597ed0d34d64a2c9d3e90c1a1b88c16562ad6ad9bb2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10a1f0914f347e3e1699246bb9f6a57a60d70724f502764e4d3f717902deb39e"
    sha256 cellar: :any_skip_relocation, ventura:        "30bc5f8f03a8706fb7fe0402571bcaeca1397fea760836a0f99ed9a8445b6ddd"
    sha256 cellar: :any_skip_relocation, monterey:       "d748f789a1daf5bd1e105b0598ad4d1279af1c5e83acdd177dfd77cd60051d45"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd76dd3a795fe9c406a33342feaeb19a0c54a954dc175f74a617e32a79038f90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64963cdf5b9c872360b4bbe9f7bde7e46ace344458003a743a9b79e44b494c69"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/nixpacks build #{testpath} --name test", 1)
    assert_match "Nixpacks was unable to generate a build plan for this app", output

    assert_equal "nixpacks #{version}", shell_output("#{bin}/nixpacks -V").chomp
  end
end