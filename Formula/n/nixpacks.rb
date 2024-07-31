class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https:nixpacks.com"
  url "https:github.comrailwayappnixpacksarchiverefstagsv1.25.0.tar.gz"
  sha256 "b8408d07aac3ed212b7dd21b6351fb5b540982f57c26d0679a97c37b8ee1e026"
  license "MIT"
  head "https:github.comrailwayappnixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e00eb964cb03c1fe2e58d0a11dfed4eff87481fac744e8637dcfa5e0999fb44"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51734997466378fe1cada1328b8b4c531399dc0fa62bcafccaf125843a1f1388"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c66722e3ec7432d8eb71d7634246606609dc326f388a872db905cfc14bcb019f"
    sha256 cellar: :any_skip_relocation, sonoma:         "a08d4da9a314ad7b3ef3927dd0bf9d6c475a36be374948fdd4102803cba85216"
    sha256 cellar: :any_skip_relocation, ventura:        "4fd4abf0579f68eadd648e0740a9b7cd99bfe12903538a1ae429589d2c188255"
    sha256 cellar: :any_skip_relocation, monterey:       "25d42cc1a213c33a5f18a2eec97642c7906f1dc80dc69fa936173cc992097527"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03767fd21220300c989dbf1ece6793636e81872c15dd735c6ee992e520bc9815"
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