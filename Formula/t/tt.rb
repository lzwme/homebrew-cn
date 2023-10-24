class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://ghproxy.com/https://github.com/tarantool/tt/releases/download/v1.3.1/tt-1.3.1-complete.tar.gz"
  sha256 "01bec0b0e27033adaf4ad6196bc08030fdb56b26f2588c8a949aa89d1427940e"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9064238c1af79d32b23c4fa5e0cbb111c02b16d96fbd874848b569dcb2488c2c"
    sha256 cellar: :any,                 arm64_ventura:  "0001c55f6cec76e89ff2ada7239f54bdc369caa67d9582d9c5e2132ac5bf2862"
    sha256 cellar: :any,                 arm64_monterey: "dd7936c4fb3802395061f08123fe10f5c453e71503c208358d74e8f2c6eb8f85"
    sha256                               sonoma:         "62faa61207f827f213937e87542477c379d734066e34ee1177b4d23fa447d04f"
    sha256                               ventura:        "5d7005f16465fe1eff3283f3386e418197c17d9aa1902dc3c0b7d90b8d7308fb"
    sha256                               monterey:       "8fb9311514888e865197101c1840d9b6c707b6454c97be1f50b8ad796a8a77c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e93fe97a80915087dccc4b13f71b7ef9b0add902e4004eead62918ff98c3993e"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "unzip"
  uses_from_macos "zip"

  on_macos do
    depends_on "bash-completion"
  end

  def install
    ENV["TT_CLI_BUILD_SSL"] = "shared"
    system "mage", "build"
    bin.install "tt"
    (etc/"tarantool").install "tt.yaml.default" => "tt.yaml"
    generate_completions_from_executable(bin/"tt", "completion", shells: [:bash, :zsh])
  end

  test do
    system bin/"tt", "init"
    system bin/"tt", "create", "cartridge", "--name", "cartridge_app", "-f", "--non-interactive", "-d", testpath
    assert_path_exists testpath/"cartridge_app/init.lua"
  end
end