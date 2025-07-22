class CargoShuttle < Formula
  desc "Build & ship backends without writing any infrastructure files"
  homepage "https://shuttle.dev"
  url "https://ghfast.top/https://github.com/shuttle-hq/shuttle/archive/refs/tags/v0.56.3.tar.gz"
  sha256 "8c42d303635fcf4faec63e5e5eb7c96c099e4326a873a4ebf2147e11a6dc25e8"
  license "Apache-2.0"
  head "https://github.com/shuttle-hq/shuttle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3a5eb7e085bfd1552c9fbcba765cb4ea2f0df91db6736b1b1796e311e91494d4"
    sha256 cellar: :any,                 arm64_sonoma:  "0837db3013e00e654547a9f230abc245c00c44fb076f14fa1020b22fe362efc1"
    sha256 cellar: :any,                 arm64_ventura: "0c684a30847132d1990d382ed68673ee3b2f7020bef772d34bd719a5d1da7f97"
    sha256 cellar: :any,                 sonoma:        "8c68470744fed86af99bb637403d48826f0eb037f7c11cd35ee21ad9a577aa4a"
    sha256 cellar: :any,                 ventura:       "07c2c639635892b2008cc4373f5256cd513881913df4250f76dab4f73d60c0d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bd5d2faafdbd05d13d746379d3ee22b7cae886c5ee69d092804719d99011236"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "618cff9fccaddef14bbb5f90fd4141ac33c1e51dfbab72b8625d3a4e3e72ecec"
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