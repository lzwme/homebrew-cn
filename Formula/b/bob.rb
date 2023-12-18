class Bob < Formula
  desc "Version manager for neovim"
  homepage "https:github.comMordechaiHadadbob"
  url "https:github.comMordechaiHadadbobarchiverefstagsv2.7.0.tar.gz"
  sha256 "ac9297395cd9d24b41aa7c5fbb9292ea46a4412ff6270447b19bda9cb4eb80ab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44de7e96ce18bb64d61e80e0d433742ef4fd80954c83424c1f7d6bb6c9494f5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ffeae9b73bd241e723c1676d46971847a8b1ac9f124ec24fae763c4a54b4d67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9653351307474b7b1d43a4a9478262086af53574c41226ebefe12853e213733"
    sha256 cellar: :any_skip_relocation, sonoma:         "07e939711e11be0dc79ff8224c43cec1e318afc04018ba9574ad87c8d9c2065b"
    sha256 cellar: :any_skip_relocation, ventura:        "8c37581b3dd1dea94285678907cce7df7e6ffbefc6666cac40128e8691b67109"
    sha256 cellar: :any_skip_relocation, monterey:       "9c9cdf35e220ad67ac6f3583ea8ea65edc8e09e3b0575ece4d2bf93fb2a35be5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "deea9d34c6db4eb8efc0f2256a463b018505f460d2a5964b408c49c657f76fee"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin"bob", "complete")
  end

  test do
    config_file = testpath"config.json"
    config_file.write <<~EOS
      {
        "downloads_location": "#{testpath}.localsharebob",
        "installation_location": "#{testpath}.localsharebobnvim-bin"
      }
    EOS
    ENV["BOB_CONFIG"] = config_file
    mkdir_p "#{testpath}.localsharebob"
    mkdir_p "#{testpath}.localsharenvim-bin"

    system "#{bin}bob", "install", "v0.9.0"
    assert_match "v0.9.0", shell_output("#{bin}bob list")
    assert_predicate testpath".localsharebobv0.9.0", :exist?
    system "#{bin}bob", "erase"
  end
end