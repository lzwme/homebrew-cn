class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.57.3.tar.gz"
  sha256 "c9d000fe812fa5470763529669a6b4adc5db945a36698361e53b73a043fe4e93"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f84ce367e731c4e28b347dfa2a49e96bd82cb1cb9be206989342c07c1ecb653"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b915c2daea6e75f18312fbfeaf815b4ce4fb14f724e769b02e286560f651fa9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a4c2780e60e36bfc7c2b3283a3e4ead60e4928666d51a7b3e06d14aeead8978"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe144f62ba6802b5b76c0e70b9d912b1b2767c5431cf926f5bf446961289565e"
    sha256 cellar: :any_skip_relocation, ventura:       "7207079e68afa4820ccd42920afa3713fa8dcee46861451b5b5e209fe7762097"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70538f3272c34bfa2457f4c591874b442f6abbd52856e6b0ca4ee33626c79f24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "893b9b690fbe97f5eff2e6d730fdb1dc0cc3fed5a3b5b8394c9c859c48010ee4"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"
    end
  end

  def post_install
    (var/"log").mkpath unless (var/"log").exist?
    (var/"dolt").mkpath
  end

  service do
    run [opt_bin/"dolt", "sql-server"]
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