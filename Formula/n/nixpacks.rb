class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https:nixpacks.com"
  url "https:github.comrailwayappnixpacksarchiverefstagsv1.23.0.tar.gz"
  sha256 "2f2aabaee17241eb8c93b34a3b67831160568035766b4d767d9ee6a1c29a1e18"
  license "MIT"
  head "https:github.comrailwayappnixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dfec4bbbf422f3de01e27459c1414e86f5bd7d97c3ff14c4d19b4d71434c10db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "504c9489b0db7e532554b569cf293ab2ff44e76370dc0ac08eb66891129bf802"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "866175bc05570dddb69bc26333974031e34258f3c7229c79d89d6eef774a169a"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ae04d4ca9a01f44c51eac29a8ddee81ec076a5cd382b36d6e0bcd72c5227b26"
    sha256 cellar: :any_skip_relocation, ventura:        "c420808b3a2873bae34f5ef02283ec72fa1eb6b5a17046d9325c63ba262b1793"
    sha256 cellar: :any_skip_relocation, monterey:       "a5e92c3894ebcf166e90b40c5e8aba8378c7da332812938ac14a50bc3a2d9602"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8d8f260827d8404acf4b9729f4f592b38170188b56f00f298c54f7333e84ada"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}nixpacks build #{testpath} --name test", 1)
    assert_match "Nixpacks was unable to generate a build plan for this app", output

    assert_equal "nixpacks #{version}", shell_output("#{bin}nixpacks -V").chomp
  end
end