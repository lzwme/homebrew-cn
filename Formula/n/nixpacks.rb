class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https:nixpacks.com"
  url "https:github.comrailwayappnixpacksarchiverefstagsv1.24.4.tar.gz"
  sha256 "56e148c0028013cbd5fa9ad9249624ab0e89a081681a80ac3e7d2e285377ec98"
  license "MIT"
  head "https:github.comrailwayappnixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b2c3b10596e563b4f5bb41bbf7f1f90f553accc0b14492c2107017f6c4b6379"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "744e55fc4049ba2da5c455ea77be58387a9ddf6e88bf88d5a6b2998c38a49c37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8f8454e83918affa0203439c5b87f82465187808c812f85378f8dc98d8b2eee"
    sha256 cellar: :any_skip_relocation, sonoma:         "41263a77fef924f5d9ef441159c6b496335d12dd5c35ce0d6932fece75878e04"
    sha256 cellar: :any_skip_relocation, ventura:        "924caf1463e71ad52df23cb8a08404d59937770b8e6e61bb76300316ea54f058"
    sha256 cellar: :any_skip_relocation, monterey:       "fea44813e77f1537eec7e926a6a506b5e880f56bf23926aff33e235bf0d3087f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f7b4d2bec88c8c42b48365593cdda7fd2a23761707786b6b3e74608b69b352b"
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