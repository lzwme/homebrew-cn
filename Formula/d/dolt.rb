class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.57.0.tar.gz"
  sha256 "eaf04146cbcab40d9f95fbfd4401a48f2be645c7155ad02be067e65ba0a23e98"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1767edb1206f82e6757c3cb578a525facd9b8adff1ae00ab9acae3c66efd0f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c927bc4d6bcc1e509459b8794a0d72483de79cb30ae91e8e21d44dd5a86098e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68be6e686ba3b7feea1d6f9112a3ae25d0e83b7bdc3a096089a48a67090d58bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "20af9bc1ccf2b56bfd87d9e5dd07ef2eeae6f5f7c3cf7c6751e0ffea3f335211"
    sha256 cellar: :any_skip_relocation, ventura:       "62c9537166b60c50c7d320cf05350bc8451e868becd97a09ac509764ade3eadd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0790900e48ce3dedbcd07048d7a95e5b2dd577b56122ae20083a389cb45ea26d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd92afc33ba9a6a3f4ec4a209f66d7fd22a8ead7885a71435e140361d0eee18e"
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