class Dolt < Formula
  desc "Git for Data"
  homepage "https://www.dolthub.com"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "98d494a1e08664589bde0200cd1b30502f5367edc3752e9796f89f4b98fe6dcd"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "89c96e979c64f8d4b88a52791536faf8d78da622d5644a7f9ce3cb2fbf5be25e"
    sha256 cellar: :any, arm64_tahoe:       "42d7f0acb59d6222c74e09f4b7589f208bc7aeefae61297cc85a568b6425adc8"
    sha256 cellar: :any, arm64_sequoia:     "25aa40955b152727f8eb608bcf72e678495165859330b99779c52e381c90fa80"
    sha256 cellar: :any, arm64_linux:       "bb0e370697c155a03b0beefd2891f5dd080d793662053882fb6d1a3396292925"
    sha256 cellar: :any, x86_64_linux:      "0dc57b807dbf28b440638adf02efe44ab855b2d8d02f8c67a6b83e40e691a707"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "go"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args, "./cmd/dolt"

    (etc/"dolt").mkpath
    touch etc/"dolt/config.yaml"
  end

  service do
    run [opt_bin/"dolt", "sql-server", "--config", etc/"dolt/config.yaml"]
    keep_alive true
    log_path var/"log/dolt.log"
    error_log_path var/"log/dolt.error.log"
    working_dir var/"dolt"
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end