class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v0.75.1.tar.gz"
  sha256 "6627b35f7ff60dafe3c9197172da1f2d233dd207cfd8cbd248f929195d695477"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8e85ad9b3ad235c1bb521d483e9afc158dc3af3265e4db908975a276459b88b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8e85ad9b3ad235c1bb521d483e9afc158dc3af3265e4db908975a276459b88b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8e85ad9b3ad235c1bb521d483e9afc158dc3af3265e4db908975a276459b88b"
    sha256 cellar: :any_skip_relocation, ventura:        "0a4ee399ca602e3cdd6e9e47b1ac008aa4b456530327cad8e9a657b1d4ab37c5"
    sha256 cellar: :any_skip_relocation, monterey:       "0a4ee399ca602e3cdd6e9e47b1ac008aa4b456530327cad8e9a657b1d4ab37c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a4ee399ca602e3cdd6e9e47b1ac008aa4b456530327cad8e9a657b1d4ab37c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca89fe2b94775ab2f0e037a25d2fbe4f5bd7bf912ad3647c640f71815825ce65"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
    end
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