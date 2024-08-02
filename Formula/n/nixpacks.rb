class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https:nixpacks.com"
  url "https:github.comrailwayappnixpacksarchiverefstagsv1.26.0.tar.gz"
  sha256 "75eb8b4c0b9a5a19db9c699ef66cf423853691c7a06140e7595d17cfd8d8d440"
  license "MIT"
  head "https:github.comrailwayappnixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8498e095d41d71b531c400763a2ac68ffa95c5e0576430dd75c60c3b236a9e3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ed59ae67aa0945bed7d1e0ffffee90ff7603f3c63fb2eb1d3b6b03fc914ee1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fb9803cd5d0ed86130495639a4674d0a6405f7f95212af9c9599155d589e940"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba7ae4c4104b6ffd32048a9a4347ac2fbafe82156091a867d05b1c6372e03661"
    sha256 cellar: :any_skip_relocation, ventura:        "b0f65ee5656ba454afb9dc0e5840685507c68cc4781b1445c67dc9040b355e8b"
    sha256 cellar: :any_skip_relocation, monterey:       "b2483bbb59a7b22073eb11a7f46d8512579a9fa1eba258920555fdb0533b2c54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a939c3abac22f11afd64dbbff06e6566bf35790fe991cfb796d5ba8b1bac1d71"
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