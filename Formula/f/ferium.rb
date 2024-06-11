class Ferium < Formula
  desc "Fast and multi-source CLI program for managing Minecraft mods and modpacks"
  homepage "https:github.comgorilla-devsferium"
  url "https:github.comgorilla-devsferiumarchiverefstagsv4.6.0.tar.gz"
  sha256 "51bdd8a7571491d8453e43222cc071edfa438412e91cd4aa4dc7ddaf2ebdde68"
  license "MPL-2.0"
  head "https:github.comgorilla-devsferium.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd28474aaaae8f1ee9505b3b7d42915e3502eefe5033a696b9193c64fef9e168"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2ae56ca002120bc80aeff75b755197c0cef6f771ff9c7f735489d9872b397e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d52569badb35fd71f500d68dd9aa906351e2963943207a1106d5c1c93ac54df"
    sha256 cellar: :any_skip_relocation, sonoma:         "a374733adea7ecf63478700235aa72c28c7e01a9301310be41bebfd9f1131c6d"
    sha256 cellar: :any_skip_relocation, ventura:        "b01f5c64339bac04fe49885ff53113e524c6515991c71d71df112b9e6628e42c"
    sha256 cellar: :any_skip_relocation, monterey:       "2bf151e70b19690c8b3db1094bbf5b2b60a8863ec323380260eff1d6befb85c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7acfaebcea18d4820cafc92781cbefe3e69d440c7b016e09c82f8196e1a79368"
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