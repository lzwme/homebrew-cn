class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "55f89b8b537feccb8f1e0e82464e7d216debd47ed1f161823050683ab803830f"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbae3d9b6cf1054276d9024a3aa490057accbdf3ede66054d000254971681d96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "698deeb0d5e3c985a3075a594ce7fd05b7f59db392c005183ca61f4eab5a67dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "223dd3a1721121ff8daeabe7507ac159bd01e15360ac6866606315808cf3bb4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e36b76baa3b500affb5c5a4c04349ac35868db6ebec59a5d89370cde8a5afdd8"
    sha256 cellar: :any,                 arm64_linux:   "7aa720ded7fcfe6aa59b22aa4c2a69a8283bc09920e6836ef382d36c4d0b5144"
    sha256 cellar: :any,                 x86_64_linux:  "820fffe1adf35b3fd6deddc86bb2d17afad908a36acd859757452248d2306cb6"
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