class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.58.4.tar.gz"
  sha256 "ca3f87bc4c998996f5c49b3c1a76c36dffa6484f029cd1968e178ef92fe8828d"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8162f07fd6743c3ae9ef9216eb02e679f1a4fca6c662233e8d863aa48b84fbc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b500885a708542e5e5d1d741e6675f5eb0a4852164d5a96c5b8c6756185e0c26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68adececb2ca52832f7387cfb4c8b671568f654799760b2d9f49c197f9ca38be"
    sha256 cellar: :any_skip_relocation, sonoma:        "b490ce7c8609f9cc019e8bd9d2bea47b924ae41fa25a48285a746a52bba99f9c"
    sha256 cellar: :any_skip_relocation, ventura:       "03a891004ff9e2d48ed381ea0eb13b303406020c52906970e7a051b707158840"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b19b1a2026288ddf3b412c4a4db1842ab168463c97c23a4ca00906fdbae8ea4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e6ef52d07f6a89fa9bf48134af8c4944ec1427fcddcd4fe1d242b881a5b2057"
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