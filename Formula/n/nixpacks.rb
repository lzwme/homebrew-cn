class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https:nixpacks.com"
  url "https:github.comrailwayappnixpacksarchiverefstagsv1.28.1.tar.gz"
  sha256 "fea44901f63d0dacb811473cf8326ed23321ad44c8225c098675650866606718"
  license "MIT"
  head "https:github.comrailwayappnixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b30d8777f6642adc8ead5163ea14608ffa76c6e1356105786d97520f1bab95da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ee7bde2ce0b973e8749d9b465953ccce0f672964539ed4998d509fdb0b783cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f06ecb9bea68edabae62bee6fc6d3579ca607a1605b5f2bf252edc8f08f55585"
    sha256 cellar: :any_skip_relocation, sonoma:         "99419bea1a928028c5af4439c69e02a30fe97173b104bfa0dce18bfcafbac9c1"
    sha256 cellar: :any_skip_relocation, ventura:        "4b538f592c65d1246d8ef5108c334467658793959909c93bdcbf7331e32926a2"
    sha256 cellar: :any_skip_relocation, monterey:       "2375236ff31c54b7fceb72dd88394a45797e3ac7ef83d5622a244f50ce98323c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42947e06d66e370bb48762f6ad1940ed066c4085e3641631cbf4c2db1a36aeeb"
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