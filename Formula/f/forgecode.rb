class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://ghfast.top/https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.13.12.tar.gz"
  sha256 "a7fd9f61a7b913b33b98b28c5df83454e200967bc2a620753e3aee7055eaf351"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd8ba4aada45f510071adc14ec8258b5263d485777a13f537baf810efceda57d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a1190bb3d8d50ba7b1955059e69dea72bce5e36bce189e47fa70533a309ce39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e62e8d932ea42ea998604f9ac1df6cdc0ffc7475b92e9f56fc7bbdec4bdee916"
    sha256 cellar: :any_skip_relocation, sonoma:        "4722f12ec0418d48b1f9c284907abddd38d085a1cbb1f36b6c7979721e90d6e0"
    sha256 cellar: :any,                 arm64_linux:   "5cd8a4636fd960c441e7872d01a6f3cec3ec6b0b87859757c53a600748e2b780"
    sha256 cellar: :any,                 x86_64_linux:  "48b6c2c6f0ccabf1134899d59588b3e825730e42aed0b58b2078509ac384e32e"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    ENV["APP_VERSION"] = version.to_s

    system "cargo", "install", *std_cargo_args(path: "crates/forge_main")
  end

  test do
    # forgecode is a TUI application
    assert_match version.to_s, shell_output("#{bin}/forge banner 2>&1")
  end
end