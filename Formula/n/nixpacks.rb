class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https:nixpacks.com"
  url "https:github.comrailwayappnixpacksarchiverefstagsv1.27.1.tar.gz"
  sha256 "e0be109b08001388b4e016cb32cefa2c0c988b18b72d75e19e24e6020a95a051"
  license "MIT"
  head "https:github.comrailwayappnixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e5b23cd80fe0b29ff54a5e4064fa3d17ccf38cc877ad4e5f4fd4368c9ab9488"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "162236dc464e40a6a3fdb7f5c7480cb48c87d9c6b29b1fc1150dfc73c7fe2c48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6132a32b7e7f1d2bd6d4ffaa29f0e2f59eb0907fbf056ac0dea413c68aba5d93"
    sha256 cellar: :any_skip_relocation, sonoma:         "9dda14af02f5b91c77b45b7d43564f610ee0f9ddcdf1bb6e72344e3c512fed8f"
    sha256 cellar: :any_skip_relocation, ventura:        "9c9d6a05a88822c8c0a57b335ee707eb2cea979bcfa7a7c38ca44879c5d3f6b8"
    sha256 cellar: :any_skip_relocation, monterey:       "9ef5b33c6803e963ca40e1cb3e28520eb541240f8ca4911062d78b98cf8c4dc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "295962f43aceffa6deb3148379910ed9ce0cf8d50f095441dcaa1677d2742948"
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