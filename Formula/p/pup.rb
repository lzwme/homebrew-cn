class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v1.10.5/pup_1.10.5_source.tar.gz"
  sha256 "347628e614f1fd803411d76d9f6deeedb3d31478d52ebb3f3d40e912c3b8e457"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e35678ded2317fa7f365af5a4cf460e7be214b5d74757ec4d65564a9080fbc44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a58e2f71f393c1ca975c060fd5a87a9a5a86582f1b026bf222991a2aa062bf88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6224eb7221ef2d8e8bfdd85839254b5efe73c1c7b70ebc79e0924008186fd497"
    sha256 cellar: :any_skip_relocation, sonoma:        "62ddfdd84b37647d2719c4cbaf3b51ab0fbf3b7416fedeb20ef92ff463f23220"
    sha256 cellar: :any,                 arm64_linux:   "956b82730d3014024b78773f8f8d0b8c723c7b87bfac3b3b1c4c3c3b679dd8f2"
    sha256 cellar: :any,                 x86_64_linux:  "c5c616b44a23661c7d33e27f524d30936c27dd1b368e4f53c82bddd6b424c23f"
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