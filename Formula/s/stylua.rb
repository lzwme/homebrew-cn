class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://ghproxy.com/https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "b227f41250925ef4aa4403cea52fbc144d1a78576eb0181b6d477ca7cf31e6bf"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fcccfaf1f593c7070baa9ade73b1ea3878871cad8e600da9a01e8105ef7bef15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76d31af05d2369622eb627f41b903b85930ea3d6580bc906eaa59f014adea297"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "653ae91e8ed8b75a84d685d8ba70b0dc35a39ace833f9dfc68807c39fc134aaa"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e36df2c568ad0de56d59be5423f39d208943ebe0c8c60caf0a7437c50270d82"
    sha256 cellar: :any_skip_relocation, ventura:        "3394e7faca9a71384a93de4997f9eb00b928e1c9dda2d4f6a55e1b4cc6803d16"
    sha256 cellar: :any_skip_relocation, monterey:       "b4e38ab887e4f48768bcf7c8e607e1640e934c91331f2ad2267d8213512c8387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99de2fa0ab46c112c2616b4f90a234fddf8286cc82cc2eef615b52943e43e2a3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args
  end

  test do
    (testpath/"test.lua").write("local  foo  = {'bar'}")
    system bin/"stylua", "test.lua"
    assert_equal "local foo = { \"bar\" }\n", (testpath/"test.lua").read
  end
end