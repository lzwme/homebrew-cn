class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://ghfast.top/https://github.com/direnv/direnv/archive/refs/tags/v2.38.1.tar.gz"
  sha256 "3bd0d49c163204543db8f22f55af8985121db24fe6b21c5b749695e4fbdbb1fe"
  license "MIT"

  bottle do
    sha256 arm64_golden_gate: "31b02d98faca1628f4e5e02e14bdccbe316043c1f5e7d5231f06edada325ff55"
    sha256 arm64_tahoe:       "173e4e1e91ca247e5638bbcbb44e4e9d9b49e233451789934d8a25fb07dac180"
    sha256 arm64_sequoia:     "553801244d17d10c5a2329b0726c33b5e85609cd225fa523e1d8a3d162c1b156"
    sha256 arm64_linux:       "9fc7bc8e468de8e5f1096b34e88868e3830c3f805e406f58008bbf089fc54577"
    sha256 x86_64_linux:      "6bac2a8c29e493dfcc14c00a35e1a5ecdad2b6e3cab0e4371b94d4dc5b5a2307"
  end

  head do
    url "https://github.com/direnv/direnv.git", branch: "master"

    depends_on "go-md2man" => :build
  end

  depends_on "go" => :build
  depends_on "bash"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "make", "install", "PREFIX=#{prefix}", "BASH_PATH=#{formula_opt_bin("bash")}/bash"
  end

  test do
    assert_match "No .envrc or .env found", shell_output("#{bin}/direnv status")

    ENV["TEST"] = "failed"
    (testpath/".envrc").write "export TEST=passed"

    assert_match "No .envrc or .env loaded", shell_output("#{bin}/direnv status")
    system bin/"direnv", "allow"

    assert_match "passed", shell_output("#{bin}/direnv exec . sh -c 'echo $TEST'")
  end
end