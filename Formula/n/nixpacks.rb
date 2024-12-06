class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https:nixpacks.com"
  url "https:github.comrailwayappnixpacksarchiverefstagsv1.30.0.tar.gz"
  sha256 "7ad4ff899f8b138d4a41568d1e2559e563a02d746a5c40050567671aa5252bae"
  license "MIT"
  head "https:github.comrailwayappnixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62af1e8866ba2b0f965e3aa8f2eed0fba68d9e6feb52b1c0a9e37984a1921249"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31d8c5bc61aa9d1a9eaa69198fa6c2c1c6359e5adbb6b18ebc899fed29e8b9e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2495657000173ab55f5d7349f0af9c349b552dae49ddf7c93b626bd5c22095f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "f809b8d0160361ccb7c8c27460c9b198922568b28f2dc4be5b665d29f996fe07"
    sha256 cellar: :any_skip_relocation, ventura:       "8bb74dc6778429254f64bf2978d96b12183ca7f775b7e1dd61e7712ea432f8b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48895751fff256408da3c662af4875397c8dec0fcfd9119ae9899bb2d139d519"
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