class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https:emo-crab.github.ioobserver_ward"
  url "https:github.comemo-crabobserver_wardarchiverefstagsv2025.5.14.tar.gz"
  sha256 "976d715127a38e80d81acf692ab0baea6195f0c248d55357aed9d1ec9c5aca64"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b69629eed25190ffbba8a35981551bf2fe66b6e6f03d96e6482bf71f770cd84d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbd3d60aa6a7b7f7c844b22a18f5029bbf41c04fe490e3d520def205d3189ebd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa33d5e0838a822f4a53190678a6b8c757def4fc435aa3c588fe29da4f583cbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "65c55f11e6b9169060d33df83e3b3bcbb8af416b9f4852f6a697592ea5247cae"
    sha256 cellar: :any_skip_relocation, ventura:       "5177e3ca1e3e7a2e2c8c329ff3328b55f737788ddabf9b606a452553a28ffd21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae219e11d36afa0c3115954b9b771164e6176667329d61e41e8ab8ec49da0845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfcd99001da2f238f4079c31dd74a4e64aff9a7407d0487cf7ce5709cf4ed31e"
  end

  depends_on "rust" => :build

  def install
    rm ".cargoconfig.toml" # disable `+crc-static`
    system "cargo", "install", *std_cargo_args(path: "observer_ward")
  end

  test do
    require "utilslinkage"

    system bin"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}observer_ward -t https:www.example.com")
  end
end