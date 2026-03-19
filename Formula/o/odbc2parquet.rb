class Odbc2parquet < Formula
  desc "CLI to query an ODBC data source and write the result into a Parquet file"
  homepage "https://github.com/pacman82/odbc2parquet"
  url "https://ghfast.top/https://github.com/pacman82/odbc2parquet/archive/refs/tags/v8.1.7.tar.gz"
  sha256 "6c5e2d212fbbf1a26190f65b454415049864f8638a44b21010c3360e25db0f69"
  license "MIT"
  head "https://github.com/pacman82/odbc2parquet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b6ec5060f3bf8e93f3535cc700e73a8f135d6d3a15be4f6a4a6fb4c19836f8ed"
    sha256 cellar: :any,                 arm64_sequoia: "cb0505a7708e86ec4294b60501eb2bff0bdf0342fba733d1687a51d2646af751"
    sha256 cellar: :any,                 arm64_sonoma:  "dfc083e8b89e660723900bc9ae689e59450caa1e05d549ebdb7563080a183e20"
    sha256 cellar: :any,                 sonoma:        "7b2555580ec6b75aafca65ffc334fa2c5b968e8b9236971cbaaf5f766db0ebeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c3a53ef61b2a974d3928d4f24d0068be453c0f50aa97a893f5ad60d7d885b70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f51a65917e3b1079ad0c2ba51db3dd933baea10515f28affb34c35a75ba7571f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "unixodbc"

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"odbc2parquet", "completions", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/odbc2parquet --version")

    system bin/"odbc2parquet", "list-data-sources"
    system bin/"odbc2parquet", "list-drivers"
  end
end