class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https:nixpacks.com"
  url "https:github.comrailwayappnixpacksarchiverefstagsv1.24.5.tar.gz"
  sha256 "624be636d462f87e6618ff1b8f6c871d597aebc1c1acf408c01301d48bd0974e"
  license "MIT"
  head "https:github.comrailwayappnixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69fbc7b5e825d01cc4164446c8d1480ce05386be2bf649aa8a65c0423d0ab131"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "434b1f46308316c1dde0209f6ae75a48541793a296250c1d898512bfd0d654b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7f573af0a09b529afca35e6090ed9ca1686d17bb95a0e6fdc361eff18484397"
    sha256 cellar: :any_skip_relocation, sonoma:         "aec1abfff43e740a1538d5060484e38c2e8ebef74027c9daf358d7aefd8be798"
    sha256 cellar: :any_skip_relocation, ventura:        "24d739d3072e30c188c675555c5d315ced2f4de127d0fe1053dbb1171c267f46"
    sha256 cellar: :any_skip_relocation, monterey:       "1042219f06f8caa8ce270bc01e669296cded2aa7e3c412da8479137c2c0015ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c713d64697cb47f548c7b4166f727cacaca414784d4fcbd8ee4762d30709b38"
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