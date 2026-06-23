class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "47c5c5abd951f3870cf838e8e979ca0340e5e22ec1ec0e0fff053a59b0a89efc"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b70b6f057c43a1a003c249f892023ae19d17a9066ab9cbce7a2666eb5b61dfc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07b24d09168f45b2a9ce006ce4a8265308573c76c975f2350f839aeb8504dbe2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "884468c8d0c4128c73aeee39dc0e0325785d54f6706c1bf6c52bf5c7d7a0c9c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "14af1f7b0dac145f788e9e04844c18cee9dbc9c405ab4ce6addf3293aae6c11b"
    sha256 cellar: :any,                 arm64_linux:   "2818747800f6f261acc85c27f9f20a2fba5204d376820e32f05fa5262b298dff"
    sha256 cellar: :any,                 x86_64_linux:  "7b7d1bacf67ce56c2f7f6f993dd63230d89c2211ff4f0fce9a7edd89fda15d95"
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