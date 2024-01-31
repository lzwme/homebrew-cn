class Ferium < Formula
  desc "Fast and multi-source CLI program for managing Minecraft mods and modpacks"
  homepage "https:github.comgorilla-devsferium"
  url "https:github.comgorilla-devsferiumarchiverefstagsv4.5.0.tar.gz"
  sha256 "c9b54673a494cecabfc62a48d03d504b6fea00af1b749c3ccb210021f8528bf0"
  license "MPL-2.0"
  head "https:github.comgorilla-devsferium.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "82e25ab023a5100d439ce6e744d28bea10f1d87a0a37428f77685dd93f187f27"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5fa5ed7e9eff088c02182dbec1c6a5168b7870a10f352ac01586eb550943dbd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "728f20dca41ef1302d295dfc1838bf1cbd4591517e3e9eba225fd21e3b79da4e"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c8ecc9751bacce526e50eef44ab0c5c715f40e23773025374cb32c8162a3bcd"
    sha256 cellar: :any_skip_relocation, ventura:        "f0eebff80a3750bf9e4cdcb3a8f6b47102c5373e3cea132144edf5791ce88054"
    sha256 cellar: :any_skip_relocation, monterey:       "9936706af64f2edd609af3872672eb1611d22e635e02c10d1ccb07de77867141"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c873cbcd04214961432292139efff05d7f229b877f14bec93f8cfaeb29b3b95b"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin"ferium", "complete")
  end

  test do
    system bin"ferium", "--help"
    ENV["FERIUM_CONFIG_FILE"] = testpath"config.json"
    system bin"ferium", "profile", "create",
                         "--game-version", "1.19",
                         "--mod-loader", "quilt",
                         "--output-dir", testpath"mods",
                         "--name", "test"
    system bin"ferium", "add", "sodium"
    system bin"ferium", "list", "--verbose"
    system bin"ferium", "upgrade"
    !Dir.glob("#{testpath}mods*.jar").empty?
  end
end