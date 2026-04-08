class Odbc2parquet < Formula
  desc "CLI to query an ODBC data source and write the result into a Parquet file"
  homepage "https://github.com/pacman82/odbc2parquet"
  url "https://ghfast.top/https://github.com/pacman82/odbc2parquet/archive/refs/tags/v10.0.1.tar.gz"
  sha256 "7313b4f47c0677b97f1feccc4988ce920dc838cf46068b61d2c5abe8e2133eab"
  license "MIT"
  head "https://github.com/pacman82/odbc2parquet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2abf50b89832333d32b98b08bc5db4c9be397ca59a2f522b8cf951f87a566a45"
    sha256 cellar: :any,                 arm64_sequoia: "32a89805eb2431bcb914573797a6e750fef202e7ff5fb8c3529416b6abb3787f"
    sha256 cellar: :any,                 arm64_sonoma:  "bdbc73bc2fb93789a99bed135998ddce9f7fd9f3662b98da84ed882ee34c582a"
    sha256 cellar: :any,                 sonoma:        "176e64a282221038a091a19825f7eeeda7a15aa17c757c5ad18f95eb217be5ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bde7fe372da6e53b2914ae9544693629e6f6485cdacc3656cbf84c4a38a77501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a2c55d3495fb281f3800fd8ee5fe73bc9f41179b504c07bb0ef5819f24911c7"
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