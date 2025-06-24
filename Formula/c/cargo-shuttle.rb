class CargoShuttle < Formula
  desc "Build & ship backends without writing any infrastructure files"
  homepage "https:shuttle.dev"
  url "https:github.comshuttle-hqshuttlearchiverefstagsv0.55.0.tar.gz"
  sha256 "63b49f09d7bf9264ea72276ac6d785f7a7c1d4722734f24c4fcc9ea77fdda59e"
  license "Apache-2.0"
  head "https:github.comshuttle-hqshuttle.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "d93f14aed3cdf581a01b4f0f979573e72268ce1cfc9c343bbf7f2ec8f091ebc1"
    sha256 cellar: :any,                 arm64_sonoma:  "9c940c83b037e820192022a602e9fd69ffc70e2c96883991069a6ccfc2ca2852"
    sha256 cellar: :any,                 arm64_ventura: "c9718b976b49883d7ce15a15c45cb6a2b6c290d06859e032d7dd9556c128808b"
    sha256 cellar: :any,                 sonoma:        "f7d74083e990b5236b937feb0ae18c6e60b94ce1f46f67f756849f3830f641e0"
    sha256 cellar: :any,                 ventura:       "9feb45fde93a91de2cbc56c7bd324bbe90e0015b1dad3c9404630c4d1edb5526"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "024ef07e6f498a0404df8a15b4f7d8bbd161312303adedaa838268f319b8c75b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95311901cbdc1d7b7012af7d1ea210268e295512c9e57816c59c6607f34af2af"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  uses_from_macos "bzip2"

  conflicts_with "shuttle-cli", because: "both install `shuttle` binaries"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args(path: "cargo-shuttle")

    # cargo-shuttle is for old platform, while shuttle is for new platform
    # see discussion in https:github.comshuttle-hqshuttlepull1878#issuecomment-2557487417
    %w[shuttle cargo-shuttle].each do |bin_name|
      generate_completions_from_executable(binbin_name, "generate", "shell")
      (man1"#{bin_name}.1").write Utils.safe_popen_read(binbin_name, "generate", "manpage")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}shuttle --version")
    assert_match "Unauthorized", shell_output("#{bin}shuttle account 2>&1", 1)
    output = shell_output("#{bin}shuttle deployment status 2>&1", 1)
    assert_match "ailed to find a Rust project in this directory.", output
  end
end