class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "1ade5a5190665fef42360719941ac8180ff65f9d23a39d0025fbbadad2e5f800"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9edefc5f1f18f8d208e640f0b1cebca1aa9271a467490496ac41ef3acf793445"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9342bc2aa42fbefd8ca90636995fdd1e0f5077fe2f1d1a4102794d1b89fc0af9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3801c3810fbe003c005c7f2c123a3c9a3127425be19a38d0ef24e5b727935d67"
    sha256 cellar: :any_skip_relocation, sonoma:        "84c2b62bb75b44d0ce19c045995736422450971a6981294c52c10bdd7646661c"
    sha256 cellar: :any,                 arm64_linux:   "b1e5cef90db2640cc410f35f6e5645ca173aa40b486ae91883be548ca768d9f3"
    sha256 cellar: :any,                 x86_64_linux:  "037af1cdf30f09428bb4126269e4d75a17814ebebd2d25d284488967932fc0fa"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pup", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pup --version")
    assert_match "Use pup CLI or generate code", shell_output("#{bin}/pup skills list")
  end
end