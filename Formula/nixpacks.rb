class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://ghproxy.com/https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "5c8566353b15120b6c3aaf83a66a1613e54f2e3a52337f9bb76ffb3d8aed2131"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a69936499343af82008828af780c3e77ebae9b4101bf70abdabf57dedfe2ce1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "981c6bbdad996eeb6e788e98b3f35b158002330eb4696d2a1ab885bf0d2808cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d768b54530d6a14b3114dd24203cb9b11a6854319eaeb4a6606a891d548b23a6"
    sha256 cellar: :any_skip_relocation, ventura:        "3ad8289046650416147489c4a85c833e32e58cc2ba3627c6281f0d655b07e676"
    sha256 cellar: :any_skip_relocation, monterey:       "bacc35a826113bff40bca680664f76d354e433a5b68d74e51e94ea2ca329eefc"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbbfa939c08d8e143cac3c108d768c354b723073929d33ca688a0f9a5fd15ee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d06e8cdfbbdb3d7f6a7f166d7eb9d0e54ef0c37e300334ca4c180da670d2f22"
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