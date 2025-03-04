class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https:nixpacks.comdocsgetting-started"
  url "https:github.comrailwayappnixpacksarchiverefstagsv1.34.0.tar.gz"
  sha256 "aa716d2039e4875e8659c453f7536aa9d6ccffff1d7547bf929a64f04297769f"
  license "MIT"
  head "https:github.comrailwayappnixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "591da985a57a4c45803f5aad35b63f5d109b03b2e5fae2843f5afcc2fdd91407"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91c5b5b827ee7e6d70374e0250f450712fd4e55551d2aa2ac5d3ec962498b00a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4f53922ce6446c79d92c7285d7098dac1f424bae2df3432b744d433dfaf366e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7b9c29c1f3d9b5c35385ecd761653420d637237fc2e0d25a6054a8f5c02e83d"
    sha256 cellar: :any_skip_relocation, ventura:       "36e82a687f49a5d65f708a694752edbfaf39e1e9fab7ec90fb49bf9fa762bcb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4d6f75d5bf8f353bc9ba3f9b286d532da3dd558d33d04f38b3003d4d4cf11a7"
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