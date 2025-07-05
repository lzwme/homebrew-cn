class CargoShuttle < Formula
  desc "Build & ship backends without writing any infrastructure files"
  homepage "https://shuttle.dev"
  url "https://ghfast.top/https://github.com/shuttle-hq/shuttle/archive/refs/tags/v0.56.1.tar.gz"
  sha256 "3676bd29d727f2be55207deaba130cf3323cbf4c9715be8e4639808265bfaa76"
  license "Apache-2.0"
  head "https://github.com/shuttle-hq/shuttle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1713fe7a70351f264b85e26d01360f2abf45a9330e32d554bfc37544e0821b8c"
    sha256 cellar: :any,                 arm64_sonoma:  "25207a013b48ee4f2fa9a78d06576710d4326155ea16c1003dd4f8c5e5ea373a"
    sha256 cellar: :any,                 arm64_ventura: "4c6bbb6beef75c307ea4f5d38a81740f633dddb3295fc0cef433fb1dfc474f56"
    sha256 cellar: :any,                 sonoma:        "5c8c4b47330e6103923834cc055085ba66434339716068304d3bc166e7c3c070"
    sha256 cellar: :any,                 ventura:       "b314cfeebace9ebcdce758910ba8124bc453cdbd244db1fa86f7d2835e9524a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a15b625c4972a5bef0d2618bb1d35f5fd3d357efa6980c5b9f449b924a5bec3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5a0c9f02a17590b04925dc44fc660c98f928f099d842938aa64e7643b70bc00"
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