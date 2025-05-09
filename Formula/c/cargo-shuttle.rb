class CargoShuttle < Formula
  desc "Build & ship backends without writing any infrastructure files"
  homepage "https:shuttle.dev"
  url "https:github.comshuttle-hqshuttlearchiverefstagsv0.54.0.tar.gz"
  sha256 "469e08c0a168cf26347a9ca5fa746154a4887ae748e1809ba54fd342f64cfa82"
  license "Apache-2.0"
  head "https:github.comshuttle-hqshuttle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1d8a79e772cadc92aa068942893197405b905080894351408be9e919dbb5f58e"
    sha256 cellar: :any,                 arm64_sonoma:  "fee93017ecccbce60465e5535dbd4ec255a62c1a63077ce124135ef0b1a63013"
    sha256 cellar: :any,                 arm64_ventura: "3de03d91bf65d8681ab1c4944431104ac39e56575dc14ec97ad1cb9f74c8cccf"
    sha256 cellar: :any,                 sonoma:        "2525c6c0cfe6ffd5c17358db32337b297064988aefcff5ad5293c422ea4fcc90"
    sha256 cellar: :any,                 ventura:       "ede971d32cee736d3c7e8e2d8bf1f9f1201efce2dff909901d681751c342d846"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44f0cab56ac4f063240b24a72cb381b263a70df203f5926175614caa615d7771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa7bae036f97a2c3b7ee866c9965aa0a283857538f0376d4cdc8251450ac2536"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  uses_from_macos "bzip2"

  conflicts_with "shuttle", because: "both install `shuttle` binaries"

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