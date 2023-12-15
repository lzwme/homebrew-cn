class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://ghproxy.com/https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "d112e905ebfb110e2d54eff9a2f71cabec9d97ecd6288a64cfc7c37bf4479401"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff66bc9da909fdf4d86b67501cc47562c88d0e1c5e872de132bfda75102754eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa57bc07cf75db137ddebf2a482c99d0d9000b63e30cecf8ac2b2c953cf0a020"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71930f1245214e88d6d996acdcb3c3d105ca360b8c7e6305a7e422c59a01acf2"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa3946701e527d3e0ac2f7f7b881b747b9b31364ffb594caa500270195fa83bd"
    sha256 cellar: :any_skip_relocation, ventura:        "f78177551225afd9c668017c79b7dba9d35f7c13218fead3d7d037c5f22b4558"
    sha256 cellar: :any_skip_relocation, monterey:       "48c2694b034d13957bfd395112e856947605e5d8f1c8196861df61c335a66e4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3df69d3423d58493ae2ebdd65f1b05a77a5899844be03ae8b55d1609536485d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/nixpacks build #{testpath} --name test", 1)
    assert_match "Nixpacks was unable to generate a build plan for this app", output

    assert_equal "nixpacks #{version}", shell_output("#{bin}/nixpacks -V").chomp
  end
end