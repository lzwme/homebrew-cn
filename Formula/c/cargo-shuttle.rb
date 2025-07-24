class CargoShuttle < Formula
  desc "Build & ship backends without writing any infrastructure files"
  homepage "https://shuttle.dev"
  url "https://ghfast.top/https://github.com/shuttle-hq/shuttle/archive/refs/tags/v0.56.4.tar.gz"
  sha256 "563496b01d393432b3625f2d4d9b7695f80c88075e6f09a7e165cd03c599e5a8"
  license "Apache-2.0"
  head "https://github.com/shuttle-hq/shuttle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d37e2a91a1b081f15dff73a41603ff28a4a3d9613052f2051e9c5d031c6866be"
    sha256 cellar: :any,                 arm64_sonoma:  "4c2800de2bb3e4b4050319cdf151e5253a82994ad8f865217078c1100a21fd02"
    sha256 cellar: :any,                 arm64_ventura: "6526c7a1ab4f127d8e1fb7e484e899c595ded47918e40527670101aa7c051787"
    sha256 cellar: :any,                 sonoma:        "57feeea8cb9b35ca735baf3537ac2e2d4ba4ae96425dfb60a21071a98ed03a40"
    sha256 cellar: :any,                 ventura:       "9f9a0be0718b6ab74657310c55428596d488972af723bf2d85d3aa469bfecbf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7827380a396d8c7a64ede4e2a363e9f8af587cf92ea25441f6d9acfdcb0e1ba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a71a5bdb282020b7400e49a7aa840917e579b5b63eb916a0977be05864ed6fa"
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
    # see discussion in https://github.com/shuttle-hq/shuttle/pull/1878/#issuecomment-2557487417
    %w[shuttle cargo-shuttle].each do |bin_name|
      generate_completions_from_executable(bin/bin_name, "generate", "shell")
      (man1/"#{bin_name}.1").write Utils.safe_popen_read(bin/bin_name, "generate", "manpage")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shuttle --version")
    assert_match "Unauthorized", shell_output("#{bin}/shuttle account 2>&1", 1)
    output = shell_output("#{bin}/shuttle deployment status 2>&1", 1)
    assert_match "ailed to find a Rust project in this directory.", output
  end
end